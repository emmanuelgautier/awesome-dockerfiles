FROM node:slim

WORKDIR /usr/src/app

COPY package*.json ./
RUN npm ci --production

COPY . ./

EXPOSE 3000

CMD [ "npm", "start" ]
