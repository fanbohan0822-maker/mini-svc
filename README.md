# mini-svc

[![CI](https://github.com/fanbohan0822-maker/mini-svc/actions/workflows/ci.yml/badge.svg)](https://github.com/fanbohan0822-maker/mini-svc/actions/workflows/ci.yml)

一个用来学 Docker 的最小 Node 服务。没有数据库、没有外部依赖，直接能跑。

## 接口

| 路径 | 说明 |
|---|---|
| `/` | 状态页，前端 fetch `/api/info` 渲染 |
| `/health` | 健康检查，返回 `{"status":"ok"}` |
| `/api/info` | 返回版本、构建时间、环境变量、Node 版本、容器 hostname |

## 环境变量

| 变量 | 默认值 | 说明 |
|---|---|---|
| `PORT` | `3000` | 监听端口 |
| `APP_VERSION` | `dev` | 应用版本，Dockerfile 里用 ENV 设默认值 |
| `GREETING` | 提示语 | 运行时通过 `-e` 传入 |
| `APP_BUILD_TIME` | `unknown` | 由构建参数 `BUILD_TIME` 注入 |

## 从 GitHub 克隆到本地

```bash
git clone https://github.com/fanbohan0822-maker/mini-svc.git
cd mini-svc
npm ci
npm start
```

然后访问 http://localhost:3000

`npm ci` 严格按照 `package-lock.json` 安装，版本和 CI 里跑的完全一致；只有本地开发需要升级依赖时才用 `npm install`。

## 本地直接跑

```bash
npm install
PORT=3100 APP_VERSION=0.1.0-local GREETING="本地" node src/server.js
```

## 构建镜像

```bash
# 基础版
docker build -t mini-svc:1.0 .

# 带构建时间（演示 ARG → ENV）
docker build --build-arg BUILD_TIME=$(date -u +%Y-%m-%dT%H:%M:%SZ) -t mini-svc:1.1 .
```

## 运行

```bash
docker run -d --name mini -p 8082:3000 \
  -e GREETING="你好，容器" \
  mini-svc:1.1
```

然后访问 http://localhost:8082

## 这个项目专门用来演示什么

1. **分层缓存**：先 `COPY package*.json` 再 `npm ci`，最后才 `COPY src`。改业务代码不会重装依赖。
2. **`.dockerignore`**：`node_modules` 不进构建上下文，镜像更小、构建更快。
3. **`ARG` 与 `ENV` 的区别**：ARG 只在构建期存在，ENV 会写进镜像成为运行时默认值。
4. **非 root 运行**：`USER node`。
5. **镜像内健康检查**：`HEALTHCHECK` 让 `docker ps` 直接显示 healthy。
