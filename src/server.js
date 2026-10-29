const express = require('express');
const os = require('os');
const path = require('path');

const app = express();
const startedAt = Date.now();

const VERSION = process.env.APP_VERSION || 'dev';
const GREETING = process.env.GREETING || '(环境变量 GREETING 没有传进来)';
const BUILD_TIME = process.env.APP_BUILD_TIME || 'unknown';

app.get('/health', (req, res) => {
  res.json({ status: 'ok' });
});

app.get('/api/info', (req, res) => {
  res.json({
    version: VERSION,
    buildTime: BUILD_TIME,
    greeting: GREETING,
    node: process.version,
    uptimeSeconds: Math.round((Date.now() - startedAt) / 1000),
    hostname: os.hostname(),
    pid: process.pid
  });
});

app.use(express.static(path.join(__dirname, '..', 'public')));

const port = Number(process.env.PORT || 3000);
app.listen(port, '0.0.0.0', () => {
  console.log(`mini-svc listening on 0.0.0.0:${port}`);
  console.log(`  version    = ${VERSION}`);
  console.log(`  buildTime  = ${BUILD_TIME}`);
  console.log(`  greeting   = ${GREETING}`);
});
// 改了一行注释 1793278041
// 又改了一行 1793278056
