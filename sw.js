const CACHE_VERSION = 'v2';
const CACHE_NAME = `twine-japan-${CACHE_VERSION}`;
const CORE_ASSETS = [
  './',
  './index.html',
  './manifest.webmanifest',
  './pwa/icon-192.png',
  './pwa/icon-512.png',
  './pwa/maskable-512.png',
];

self.addEventListener('install', (event) => {
  self.skipWaiting();
  event.waitUntil(
    caches.open(CACHE_NAME).then((cache) => cache.addAll(CORE_ASSETS))
  );
});

self.addEventListener('activate', (event) => {
  event.waitUntil(
    (async () => {
      const keys = await caches.keys();
      await Promise.all(
        keys
          .filter((key) => key !== CACHE_NAME)
          .map((key) => caches.delete(key))
      );

      await self.clients.claim();
      const clientList = await self.clients.matchAll({
        type: 'window',
        includeUncontrolled: true,
      });

      for (const client of clientList) {
        if (!client.url) continue;
        const url = new URL(client.url);
        if (url.origin !== self.location.origin) continue;
        if (typeof client.navigate === 'function') {
          client.navigate(client.url).catch(() => {});
        }
      }
    })()
  );
});

self.addEventListener('fetch', (event) => {
  if (event.request.method !== 'GET') {
    return;
  }

  if (
    event.request.cache === 'only-if-cached' &&
    event.request.mode !== 'same-origin'
  ) {
    return;
  }

  event.respondWith(
    (async () => {
      try {
        const networkResponse = await fetch(event.request);
        const cache = await caches.open(CACHE_NAME);
        cache.put(event.request, networkResponse.clone()).catch(() => {});
        return networkResponse;
      } catch (error) {
        const cachedResponse = await caches.match(event.request);
        if (cachedResponse) {
          return cachedResponse;
        }

        if (event.request.mode === 'navigate') {
          const fallback = await caches.match('./index.html');
          if (fallback) {
            return fallback;
          }
        }

        throw error;
      }
    })()
  );
});
