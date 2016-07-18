#
# An example Dockerfile for the docker-quickstart repository
#
# This Dockerfile demonstrates how to define a Docker image. For the tutorial,
# we'll build a basic Jekyll image that can compile and serve static websites.
#
# For an analysis of the instructions in this file, read the section in this
# guide:
#
#   tutorial/building-images-from-dockerfiles/
#
# For the full Dockerfile reference, please see the Docker docs:
#
#   https://docs.docker.com/engine/reference/builder/
#
# Docker ignores comment lines beginning with "#".
#

FROM ruby:2.3.1-alpine
MAINTAINER Cy Rossignol <cy@rossignols.me>

ENV LANGUAGE=en_US \
    LANG=en_US.UTF-8 \
    LC_ALL=en_US

RUN apk add --no-cache --virtual jekyll-build-deps \
    build-base \
    ruby-dev \
 && apk add --no-cache ruby-io-console

RUN gem update --system && gem install jekyll

RUN apk del jekyll-build-deps libffi-dev openssl-dev yaml-dev zlib-dev \
 && rm /usr/local/bundle/cache/*

RUN mkdir -p /src/docker-quickstart

COPY ./ /src/docker-quickstart

WORKDIR /src/docker-quickstart

EXPOSE 4000

CMD ["serve","-H","0.0.0.0","."]
ENTRYPOINT ["jekyll"]
