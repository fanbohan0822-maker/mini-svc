FROM node:22-alpine

WORKDIR /app

COPY package.json package-lock.json .npmrc ./
RUN npm ci --omit=dev

COPY src ./src
COPY public ./public

ARG BUILD_TIME=unknown
ENV APP_BUILD_TIME=$BUILD_TIME
ENV APP_VERSION=1.0.0
ENV NODE_ENV=production

EXPOSE 3000

HEALTHCHECK --interval=30s --timeout=3s --start-period=10s \
  CMD wget -q --spider http://localhost:3000/health || exit 1

USER node

CMD ["node", "src/server.js"]
