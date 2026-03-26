FROM node:lts-slim

WORKDIR /usr/src/app

COPY package.json yarn.lock ./
RUN yarn install --frozen-lockfile --production && yarn cache clean

COPY . ./

EXPOSE 3000

CMD [ "yarn", "start" ]
