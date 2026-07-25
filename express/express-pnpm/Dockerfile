FROM node:lts-slim@sha256:6f7b03f7c2c8e2e784dcf9295400527b9b1270fd37b7e9a7285cf83b6951452d

LABEL org.opencontainers.image.title="Express.js (pnpm) Docker Example" \
      org.opencontainers.image.description="Express.js application containerized with Docker" \
      org.opencontainers.image.source="https://github.com/emmanuelgautier/awesome-dockerfiles" \
      org.opencontainers.image.licenses="MIT"

WORKDIR /usr/src/app

RUN corepack enable

COPY package.json pnpm-lock.yaml ./
RUN pnpm install --frozen-lockfile --prod

COPY . ./

USER node

EXPOSE 3000

HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD ["node", "-e", "require('http').get('http://localhost:3000/', r => process.exit(r.statusCode < 400 ? 0 : 1)).on('error', () => process.exit(1))"]

CMD [ "pnpm", "start" ]
