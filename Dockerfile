# syntax=docker/dockerfile:1

##########
# Builder
##########
FROM ruby:3.2.0-slim AS builder

ENV RAILS_ENV=production \
    RACK_ENV=production \
    BUNDLE_WITHOUT="development:test" \
    BUNDLE_PATH=/usr/local/bundle

# 必要最低限のパッケージ
RUN apt-get update -qq && \
    apt-get install -y --no-install-recommends \
      build-essential libpq-dev git curl \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /rails

# Gem だけ先に入れてキャッシュを効かせる
COPY Gemfile Gemfile.lock ./
RUN bundle lock --add-platform x86_64-linux || true && \
    bundle install --jobs=4 --retry=3

# アプリ本体
COPY . .

# bin の権限 & CRLF対策（あれば）
RUN find bin -type f -exec sed -i 's/\r$//' {} \; -exec chmod +x {} \; || true

# JS 依存がある場合だけインストール（package.json があるときだけ）
# ※ 必要なら node を別途入れてください（この例では不要前提）
RUN if [ -f package.json ]; then \
      echo "package.json detected but Node is not installed in this image. Install Node if needed."; \
    fi

# bootsnap（失敗しても無視）
RUN bundle exec bootsnap precompile app/ lib/ || true

# アセット precompile（SECRET_KEY_BASE ダミーでOK）
RUN SECRET_KEY_BASE_DUMMY=1 bundle exec rails assets:precompile

##########
# Final
##########
FROM ruby:3.2.0-slim

ENV RAILS_ENV=production \
    RACK_ENV=production

RUN apt-get update -qq && \
    apt-get install -y --no-install-recommends \
      libpq5 \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /rails

COPY --from=builder /usr/local/bundle /usr/local/bundle
COPY --from=builder /rails /rails

EXPOSE 3000
CMD ["bundle", "exec", "puma", "-C", "config/puma.rb"]




