# syntax = docker/dockerfile:1

# Ruby version must match .ruby-version / Gemfile
ARG RUBY_VERSION=3.2.8
FROM registry.docker.com/library/ruby:${RUBY_VERSION}-slim AS base

# App root
WORKDIR /rails

# Production bundler/env
ENV RAILS_ENV=production \
    RAILS_SERVE_STATIC_FILES=true \
    BUNDLE_DEPLOYMENT=1 \
    BUNDLE_PATH=/usr/local/bundle \
    BUNDLE_WITHOUT="development test"

# =========================
# Build stage
# =========================
FROM base AS build

# System deps for building native gems
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y \
      build-essential git pkg-config libpq-dev libyaml-dev \
    && rm -rf /var/lib/apt/lists /var/cache/apt/archives

# Install gems with cache efficiency
COPY Gemfile Gemfile.lock ./
# In case lockfile lacks linux platform (no-op if already present)
RUN bundle lock --add-platform x86_64-linux || true
RUN bundle install && \
    rm -rf ~/.bundle "${BUNDLE_PATH}"/ruby/*/cache "${BUNDLE_PATH}"/ruby/*/bundler/gems/*/.git

# App code
COPY . .

# Ensure binstubs/entrypoint are executable & LF line endings
RUN chmod +x bin/* || true && sed -i 's/\r$//' bin/* || true

# (Optional) bootsnap precompile; don't fail the build if it errors
RUN bundle exec bootsnap precompile app/ lib/ || true

# Precompile assets without master key (OK if credentials not needed at compile)
RUN SECRET_KEY_BASE_DUMMY=1 bundle exec rails assets:precompile

# =========================
# Final runtime image
# =========================
FROM base AS app

# Runtime deps (pg client & image processing)
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y \
      curl libjemalloc2 libpq5 imagemagick \
    && rm -rf /var/lib/apt/lists /var/cache/apt/archives

# Bring in gems and app
COPY --from=build /usr/local/bundle /usr/local/bundle
COPY --from=build /rails /rails

# Non-root user & ownership
RUN useradd rails --create-home --shell /bin/bash && \
    chown -R rails:rails db log storage tmp
USER rails:rails

# Rails container entrypoint (db prepare, etc.)
ENTRYPOINT ["/rails/bin/docker-entrypoint"]

# Web
EXPOSE 3000
# Start app (Puma via config/puma.rb があればこちらでもOK)
CMD ["bundle", "exec", "puma", "-C", "config/puma.rb"]
