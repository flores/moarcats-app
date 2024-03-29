ARG RUBY_VERSION=3.1

FROM docker.io/library/ruby:${RUBY_VERSION}-slim-buster AS build-image

RUN set -eux;\
  apt-get update; \
  apt-get install -y build-essential

ADD Gemfile Gemfile.lock /
RUN gem install -v 2.3.20 bundler && bundle install

FROM docker.io/library/ruby:${RUBY_VERSION}-slim-buster

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

USER nobody
CMD ["rake", "puma:start"]
