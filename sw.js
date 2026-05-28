// Siatar PWA Service Worker
// v2.7.0 - 极简离线缓存策略
// 设计原则：
//   - 只缓存 index.html 和 manifest.json（应用 shell）
//   - 不缓存 localStorage 数据（数据完全本地，无需 SW 介入）
//   - 网络优先 + 离线兜底：在线时永远拿最新版，离线时回退到缓存
//   - 新版本发布后，旧 SW 自动失效（CACHE_NAME 改了即可）

const CACHE_NAME = 'siatar-v2.7.0';
const APP_SHELL = [
  './',
  './index.html',
  './manifest.json'
];

self.addEventListener('install', (event) => {
  // 立即激活新 SW，不等待旧 SW 关闭
  self.skipWaiting();
  event.waitUntil(
    caches.open(CACHE_NAME).then((cache) => cache.addAll(APP_SHELL))
      .catch(() => { /* 离线安装也允许通过 */ })
  );
});

self.addEventListener('activate', (event) => {
  // 清理旧版本缓存
  event.waitUntil(
    caches.keys().then((keys) =>
      Promise.all(
        keys.filter((k) => k !== CACHE_NAME).map((k) => caches.delete(k))
      )
    ).then(() => self.clients.claim())
  );
});

self.addEventListener('fetch', (event) => {
  const req = event.request;

  // 只处理 GET
  if (req.method !== 'GET') return;

  // 只处理同源请求（避免误缓存第三方）
  const url = new URL(req.url);
  if (url.origin !== self.location.origin) return;

  // 网络优先策略
  event.respondWith(
    fetch(req)
      .then((res) => {
        // 成功获取，顺便更新缓存
        if (res && res.status === 200 && res.type === 'basic') {
          const copy = res.clone();
          caches.open(CACHE_NAME).then((cache) => cache.put(req, copy));
        }
        return res;
      })
      .catch(() => {
        // 离线 -> 走缓存
        return caches.match(req).then((cached) => {
          if (cached) return cached;
          // 对于导航请求，回退到 index.html（SPA 风格）
          if (req.mode === 'navigate') {
            return caches.match('./index.html');
          }
          return new Response('离线且无缓存', { status: 503, statusText: 'Offline' });
        });
      })
  );
});

// 支持手动触发更新：页面里调用 navigator.serviceWorker.controller.postMessage('SKIP_WAITING')
self.addEventListener('message', (event) => {
  if (event.data === 'SKIP_WAITING') self.skipWaiting();
});
