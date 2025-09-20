# syntax=docker/dockerfile:1

########################
# Builder
########################
FROM ruby:3.2.0-slim AS builder

ENV RAILS_ENV=production \
    RACK_ENV=production \
    BUNDLE_WITHOUT="development:test" \
    BUNDLE_PATH=/usr/local/bundle

# OS 依存
RUN apt-get update -qq && \
    apt-get install -y --no-install-recommends \
      build-essential libpq-dev git curl \
      nodejs npm \
      imagemagick \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /rails

# bin/ の権限と改行コード（CRLF）対策
COPY bin/ ./bin/
RUN sed -i 's/\r$//' bin/* && chmod +x bin/*

# Gem 先に入れる
COPY Gemfile Gemfile.lock ./
RUN bundle lock --add-platform x86_64-linux || true && \
    bundle install --jobs=4 --retry=3

# Node 依存（あれば）
COPY package.json yarn.lock* package-lock.json* ./
RUN if [ -f package.json ]; then \
      if [ -f yarn.lock ]; then npm install -g yarn && yarn install --frozen-lockfile; \
      elif [ -f package-lock.json ]; then npm ci; \
      fi; \
    fi

# アプリ本体
COPY . .

# bootsnap は任意（失敗しても無視）
RUN bundle exec bootsnap precompile app/ lib/ || true

# assets:precompile（SECRET_KEY_BASE ダミーでOK）
RUN SECRET_KEY_BASE_DUMMY=1 bundle exec rails assets:precompile

########################
# Final
########################
FROM ruby:3.2.0-slim

ENV RAILS_ENV=production \
    RACK_ENV=production

# 本番に必要なランタイムだけ
RUN apt-get update -qq && \
    apt-get install -y --no-install-recommends \
      libpq5 imagemagick \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /rails

# bundler & アプリをコピー
COPY --from=builder /usr/local/bundle /usr/local/bundle
COPY --from=builder /rails /rails

EXPOSE 3000
CMD ["bundle", "exec", "puma", "-C", "config/puma.rb"]



