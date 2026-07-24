ARG RUBY_VERSION=3.4.10

FROM ruby:${RUBY_VERSION}-slim AS base

WORKDIR /rails

ENV RAILS_ENV=production \
    BUNDLE_DEPLOYMENT=1 \
    BUNDLE_PATH=/usr/local/bundle \
    BUNDLE_WITHOUT=development:test

FROM base AS build

RUN apt-get update && apt-get install -y --no-install-recommends \
        build-essential=12.12 \
        libyaml-dev=0.2.5-2 \
        pkg-config=1.8.1-4 \
    && rm -rf /var/lib/apt/lists/*

COPY Gemfile Gemfile.lock ./
RUN bundle install \
    && rm -rf "${BUNDLE_PATH}"/ruby/*/cache

COPY . .

RUN SECRET_KEY_BASE_DUMMY=1 ./bin/rails assets:precompile \
    && rm -rf log/* tmp/cache

FROM base AS runtime

RUN apt-get update && apt-get install -y --no-install-recommends \
        curl=8.14.1-2+deb13u4 \
        libsqlite3-0=3.46.1-7+deb13u1 \
    && rm -rf /var/lib/apt/lists/* \
    && groupadd --gid 1000 rails \
    && useradd --uid 1000 --gid rails --create-home --shell /bin/bash rails

COPY --from=build --chown=rails:rails "${BUNDLE_PATH}" "${BUNDLE_PATH}"
COPY --from=build --chown=rails:rails /rails /rails

COPY docker/entrypoint.sh /usr/local/bin/docker-entrypoint
RUN chmod +x /usr/local/bin/docker-entrypoint

USER rails:rails

EXPOSE 3000

HEALTHCHECK --interval=30s --timeout=3s --start-period=10s --retries=3 \
    CMD curl --fail http://localhost:3000/up || exit 1

ENTRYPOINT ["docker-entrypoint"]
CMD ["./bin/rails", "server"]
