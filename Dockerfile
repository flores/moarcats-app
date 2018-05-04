FROM ruby:2.4-alpine

ARG SOURCE_COMMIT
ENV SOURCE_COMMIT=$SOURCE_COMMIT
ENV APP_HOME=/opt/moarcats
ENV RACK_ENV=production
ENV PORT=8080
ENV CATS_DIR=/cats

EXPOSE $PORT

RUN apk update && \
    apk add --no-cache ruby-bundler && \
    apk add --no-cache --virtual .build-deps git build-base gcc \
	abuild binutils linux-headers

WORKDIR $APP_HOME
VOLUME /cats
ADD Gemfile $APP_HOME
#ADD Gemfile.lock $APP_HOME
RUN bundle install && \
    apk del .build-deps
COPY . $APP_HOME
USER nobody
CMD rake puma:start
