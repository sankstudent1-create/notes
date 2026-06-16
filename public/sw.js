/* SW Notes — Service Worker v2 */
var CACHE = 'sw-notes-v2';
var OFFLINE_URLS = ['/', '/index.html'];

self.addEventListener('install', function(e) {
  e.waitUntil(
    caches.open(CACHE).then(function(cache) {
      return cache.addAll(OFFLINE_URLS);
    }).then(function() {
      return self.skipWaiting();
    })
  );
});

self.addEventListener('activate', function(e) {
  e.waitUntil(
    caches.keys().then(function(keys) {
      return Promise.all(
        keys.filter(function(k) { return k !== CACHE; })
            .map(function(k) { return caches.delete(k); })
      );
    }).then(function() {
      return self.clients.claim();
    })
  );
});

self.addEventListener('fetch', function(e) {
  /* Only handle GET, skip Supabase/API calls */
  if (e.request.method !== 'GET') return;
  if (e.request.url.indexOf('supabase.co') > -1) return;
  if (e.request.url.indexOf('fonts.googleapis.com') > -1) return;

  e.respondWith(
    caches.match(e.request).then(function(cached) {
      if (cached) return cached;
      return fetch(e.request).then(function(res) {
        var clone = res.clone();
        caches.open(CACHE).then(function(cache) { cache.put(e.request, clone); });
        return res;
      }).catch(function() {
        return caches.match('/index.html');
      });
    })
  );
});
