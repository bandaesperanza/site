// Service worker de la Partothèque — met en cache la coquille de l'app
// (HTML/manifest/icônes) pour qu'elle s'ouvre même sans réseau.
// Les PDF, eux, sont gérés séparément côté page (IndexedDB), pas ici.

const CACHE_NAME = 'partotheque-shell-v2';

// ⚠️ À VÉRIFIER : mets ici le nom exact du fichier HTML principal tel
// qu'il est réellement déployé (celui que tu utilises pour "Ajouter à
// l'écran d'accueil"). C'était './partotheque-hors-ligne.html' dans la
// version précédente, un fichier qui ne semble correspondre à rien —
// c'est très probablement la cause du problème : si ce fichier n'existe
// pas à cette adresse, l'installation du service worker échoue en
// entier (cache.addAll est "tout ou rien"), et rien n'est jamais mis en
// cache, jamais, même après avoir ouvert l'app cent fois en wifi.
const APP_SHELL_URL = './index.html';

const SHELL_FILES = [
  APP_SHELL_URL,
  './manifest.json',
  './icon-192.png',
  './icon-512.png',
];

self.addEventListener('install', (event) => {
  event.waitUntil(
    caches.open(CACHE_NAME).then((cache) =>
      // On met chaque fichier en cache indépendamment : si l'un d'eux
      // échoue (mauvais nom, 404...), les autres sont quand même mis en
      // cache, et l'appli reste utilisable hors-ligne au moins pour le
      // reste — au lieu de tout perdre comme avec cache.addAll().
      Promise.all(
        SHELL_FILES.map((url) =>
          cache.add(url).catch((err) => {
            console.error('[SW] Échec de mise en cache de', url, err);
          })
        )
      )
    )
  );
  self.skipWaiting();
});

self.addEventListener('activate', (event) => {
  event.waitUntil(
    caches.keys()
      .then((names) =>
        Promise.all(names.filter((n) => n !== CACHE_NAME).map((n) => caches.delete(n)))
      )
      .then(() => self.clients.claim())
  );
});

self.addEventListener('fetch', (event) => {
  const req = event.request;
  if (req.method !== 'GET') return;

  // Toute navigation (ouverture de l'app depuis l'icône écran d'accueil,
  // un lien, un rechargement...) doit servir la coquille HTML — réseau
  // d'abord pour avoir la dernière version, cache en secours si le
  // réseau ne répond pas. On ne dépend plus de faire correspondre
  // exactement l'URL demandée à un nom de fichier : peu importe
  // comment le navigateur formule la requête (avec ou sans paramètres,
  // avec ou sans "/" final...), une navigation reste une navigation.
  if (req.mode === 'navigate') {
    event.respondWith(
      fetch(req)
        .then((res) => {
          const copy = res.clone();
          caches.open(CACHE_NAME).then((cache) => cache.put(APP_SHELL_URL, copy));
          return res;
        })
        .catch(() => caches.match(APP_SHELL_URL))
    );
    return;
  }

  // Pour le reste de la coquille (manifest, icônes) : même stratégie
  // "réseau d'abord, cache en secours", mais seulement pour ces
  // fichiers précis — les PDF et autres requêtes ne sont pas concernés.
  const isShellAsset = SHELL_FILES.some((f) => req.url.endsWith(f.replace('./', '')));
  if (!isShellAsset) return;

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
