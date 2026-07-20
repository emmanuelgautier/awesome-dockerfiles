FROM node:lts-slim

WORKDIR /usr/src/app

RUN corepack enable

COPY package.json pnpm-lock.yaml ./
RUN pnpm install --frozen-lockfile --prod

COPY . ./

EXPOSE 3000

CMD [ "pnpm", "start" ]
