FROM node:lts as development

WORKDIR /app

COPY package*.json ./
RUN npm ci

COPY . .

ENV CI=true
ENV PORT=3000

CMD [ "npm", "start" ]

FROM development as builder

RUN npm run build

FROM nginx:alpine

# Copy config nginx
COPY --from=builder /app/.nginx/nginx.conf /etc/nginx/conf.d/default.conf

WORKDIR /usr/share/nginx/html

# Remove default nginx static assets
RUN rm -rf ./*

# Copy static assets from builder stage
COPY --from=builder /app/dist .
