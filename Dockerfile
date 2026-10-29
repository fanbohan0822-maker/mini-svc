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

# 必须用 127.0.0.1，不能用 localhost：
# 容器里 localhost 解析成 IPv6 的 ::1，而 node 只监听 IPv4 的 0.0.0.0，
# 用 localhost 会得到 Connection refused，容器被标记 unhealthy
HEALTHCHECK --interval=30s --timeout=3s --start-period=10s \
  CMD wget -q --spider http://127.0.0.1:3000/health || exit 1

USER node

CMD ["node", "src/server.js"]
