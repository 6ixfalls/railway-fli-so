# syntax=docker.io/docker/dockerfile:1
FROM alpine:3.21 AS core
RUN apk add --no-cache git
ARG DEPLOY_GIT_TAG=main
RUN git clone https://github.com/thisuxhq/fli.so.git --depth=1 --branch=$DEPLOY_GIT_TAG /tmp/source/
WORKDIR /tmp/source

FROM oven/bun:latest

# Deviation: add stripe args
ARG STRIPE_SECRET_KEY=sk_live_dummy

WORKDIR /app
COPY --from=core package.json package.json
RUN bun install

COPY --from=core /tmp/source /app
RUN bun run build

EXPOSE 3000
CMD ["bun", "--bun", "build/index.js"]
