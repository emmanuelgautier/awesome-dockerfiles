# NestJS Docker

## Description

A Dockerfile to build production-ready NestJS app docker image. The Dockerfile can also be found on this [snippet](https://www.emmanuelgautier.com/blog/snippets/nestjs-dockerfile) page.

## Installation

```bash
$ npm install
```

## Build Docker Image

```bash
$ docker build . -t nestjs-app
```

## Running the app

```bash
# development
$ npm run start

# watch mode
$ npm run start:dev

# production mode
$ npm run start:prod
```

## Test

```bash
# unit tests
$ npm run test

# e2e tests
$ npm run test:e2e

# test coverage
$ npm run test:cov
```
