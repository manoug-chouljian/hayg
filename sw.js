const CACHE_NAME = 'hayg-v1';
const ASSETS = [
  './',
  './index.html',
  './faces-game.html',
  './spelling-bee.html',
  './typing-game.html',
  './wordle.html',
  './ztype-game.html',
  './css/style.css',
  './css/index.css',
  './css/shared.css',
  './css/faces-game.css',
  './css/spelling-bee.css',
  './css/typing-game.css',
  './css/wordle.css',
  './css/ztype-game.css',
  './js/api.js',
  './js/app.js',
  './js/index.js',
  './js/faces-game.js',
  './js/spelling-bee.js',
  './js/typing-game.js',
  './js/wordle.js',
  './js/ztype-game.js',
  './js/words.js',
  './pics/logo.png',
  './manifest.json'
];

// Install event - caching assets
self.addEventListener('install', (event) => {
  event.waitUntil(
    caches.open(CACHE_NAME).then((cache) => {
      return cache.addAll(ASSETS);
    })
  );
});

// Activate event - cleanup old caches
self.addEventListener('activate', (event) => {
  event.waitUntil(
    caches.keys().then((keys) => {
      return Promise.all(
        keys.filter((key) => key !== CACHE_NAME).map((key) => caches.delete(key))
      );
    })
  );
});

// Fetch event - serving from cache
self.addEventListener('fetch', (event) => {
  // Ignore external API calls (Supabase)
  if (event.request.url.includes('supabase.co')) return;

  event.respondWith(
    caches.match(event.request).then((response) => {
      return response || fetch(event.request);
    })
  );
});
