// Service worker de la Partothèque — met en cache la coquille de l'app
// (HTML/manifest/icônes) pour qu'elle s'ouvre même sans réseau.
// Les PDF, eux, sont gérés séparément côté page (IndexedDB), pas ici.

const CACHE_NAME = 'partotheque-shell-v1';
const SHELL_FILES = [
  './partotheque-hors-ligne.html',
  './manifest.json',
  './icon-192.png',
  './icon-512.png',
];

self.addEventListener('install', (event) => {
  event.waitUntil(
    caches.open(CACHE_NAME).then((cache) => cache.addAll(SHELL_FILES))
  );
  self.skipWaiting();
});

self.addEventListener('activate', (event) => {
  event.waitUntil(
    caches.keys().then((names) =>
      Promise.all(names.filter((n) => n !== CACHE_NAME).map((n) => caches.delete(n)))
    )
  );
  self.clients.claim();
});

// Stratégie "réseau d'abord, cache en secours" pour la coquille de l'app :
// on veut toujours la dernière version si le réseau est là, mais l'app doit
// quand même s'ouvrir hors-ligne.
self.addEventListener('fetch', (event) => {
  const req = event.request;
  if (req.method !== 'GET') return;
  if (!SHELL_FILES.some((f) => req.url.endsWith(f.replace('./', '')))) return;

  event.respondWith(
    fetch(req)
      .then((res) => {
        const copy = res.clone();
        caches.open(CACHE_NAME).then((cache) => cache.put(req, copy));
        return res;
      })
      .catch(() => caches.match(req))
  );
});
