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

FROM nginx:alpine@sha256:785835ea65db4bba6f021acc0f3be91b0fef76a53fe41f8588c6698d2aed0606

LABEL org.opencontainers.image.title="Astro Docker Example" \
      org.opencontainers.image.description="Astro application containerized with Docker" \
      org.opencontainers.image.source="https://github.com/emmanuelgautier/awesome-dockerfiles" \
      org.opencontainers.image.licenses="MIT"

# Copy config nginx
COPY --from=builder /app/.nginx/nginx.conf /etc/nginx/conf.d/default.conf

WORKDIR /usr/share/nginx/html

# Remove default nginx static assets
RUN rm -rf ./*

# Copy static assets from builder stage
COPY --from=builder /app/dist .

EXPOSE 80

HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD wget --no-verbose --tries=1 --spider http://localhost/ || exit 1
