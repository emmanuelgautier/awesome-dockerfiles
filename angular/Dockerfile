FROM node:lts-slim@sha256:6f7b03f7c2c8e2e784dcf9295400527b9b1270fd37b7e9a7285cf83b6951452d AS development

WORKDIR /app

COPY package*.json ./
RUN npm ci

COPY . .

ENV CI=true
ENV PORT=3000

CMD [ "npm", "start" ]

FROM development AS builder

RUN npm run build

FROM nginx:alpine@sha256:4a73073bd557c65b759505da037898b61f1be6cbcc3c2c3aeac22d2a470c1752

LABEL org.opencontainers.image.title="Angular Docker Example" \
      org.opencontainers.image.description="Angular application containerized with Docker" \
      org.opencontainers.image.source="https://github.com/emmanuelgautier/awesome-dockerfiles" \
      org.opencontainers.image.licenses="MIT"

# Copy config nginx
COPY --from=builder /app/.nginx/nginx.conf /etc/nginx/conf.d/default.conf

WORKDIR /usr/share/nginx/html

# Remove default nginx static assets
RUN rm -rf ./*

# Copy static assets from builder stage
COPY --from=builder /app/dist/angular/browser .

EXPOSE 80

HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD wget --no-verbose --tries=1 --spider http://localhost/ || exit 1
