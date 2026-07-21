FROM node:lts as builder

WORKDIR /app

COPY package*.json ./
RUN npm ci

COPY . .

RUN npm run build

FROM node:lts-alpine

WORKDIR /app

ENV NODE_ENV production

COPY --from=builder --chown=node:node /app/.output ./.output

USER node

EXPOSE 3000

ENV PORT 3000
ENV HOSTNAME "0.0.0.0"

CMD ["node", ".output/server/index.mjs"]
