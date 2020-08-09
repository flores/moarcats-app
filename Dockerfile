ARG RUBY_VERSION=2.7

FROM ruby:$RUBY_VERSION-slim-buster AS build-image

ADD Gemfile /

RUN set -eux; \
    apt-get update; \
    apt-get install -y --no-install-recommends \
      build-essential; \
    gem install bundler; \
    bundle install

FROM ruby:$RUBY_VERSION-slim-buster

ENV APP_HOME=/opt/moarcats
ENV RACK_ENV=production
ENV PORT=5000
ENV CATS_DIR=/cats

EXPOSE $PORT

COPY --from=build-image /usr/local/bundle /usr/local/bundle
COPY --from=build-image /Gemfile.lock $APP_HOME/Gemfile.lock

WORKDIR $APP_HOME
VOLUME /cats
ADD Gemfile $APP_HOME
COPY . $APP_HOME

# basic smoke check
RUN set -eux; \
    bundle env

USER nobody
CMD ["rake", "puma:start"]
