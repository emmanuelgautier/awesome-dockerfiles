FROM node:slim

WORKDIR /usr/src/app

COPY package.json yarn.lock ./
RUN yarn install --frozen-lockfile --production

COPY . ./

EXPOSE 3000

CMD [ "yarn", "start" ]
