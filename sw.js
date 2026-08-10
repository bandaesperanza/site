// Service worker de la Partothèque — met en cache la coquille de l'app
// (HTML/manifest/icônes) pour qu'elle s'ouvre même sans réseau, ainsi
// que les librairies externes figées par version (pdf.js), sans
// lesquelles le lecteur de partitions ne peut pas s'afficher hors-ligne.
// Les PDF eux-mêmes sont gérés séparément côté page (IndexedDB), pas ici.

const CACHE_NAME = 'partotheque-shell-v4';

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

// Librairies externes chargées depuis une CDN, dont le lecteur PDF a
// besoin pour fonctionner. Leur URL contient un numéro de version figé
// (3.11.174) : le contenu ne changera donc jamais tant que le <script>
// dans index.html pointe vers cette même version — on peut les mettre
// en cache "à vie" sans risque de servir une version périmée.
// ⚠️ Si tu changes la version de pdf.js dans index.html, mets-la à jour
// ici aussi, sinon l'ancienne version restera servie depuis le cache.
const LIB_FILES = [
  'https://cdnjs.cloudflare.com/ajax/libs/pdf.js/3.11.174/pdf.min.js',
  'https://cdnjs.cloudflare.com/ajax/libs/pdf.js/3.11.174/pdf.worker.min.js',
];

self.addEventListener('install', (event) => {
  event.waitUntil(
    caches.open(CACHE_NAME).then((cache) =>
      // On met chaque fichier en cache indépendamment : si l'un d'eux
      // échoue (mauvais nom, 404, CDN indisponible...), les autres sont
      // quand même mis en cache, et l'appli reste utilisable hors-ligne
      // au moins pour le reste — au lieu de tout perdre comme avec
      // cache.addAll().
      Promise.all(
        [...SHELL_FILES, ...LIB_FILES].map((url) =>
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
  // un lien, un rechargement...) sert la coquille HTML depuis le cache
  // en priorité — instantané, même en mauvaise connexion (pas d'attente
  // d'un timeout réseau). Le réseau n'est utilisé que si rien n'est
  // encore en cache (tout premier lancement) ; ensuite, la mise à jour
  // ne se fait que via le bouton "Actualiser" (message REFRESH_SHELL
  // plus bas), pas automatiquement à chaque ouverture.
  if (req.mode === 'navigate') {
    event.respondWith(
      caches.match(APP_SHELL_URL).then((cached) => {
        if (cached) return cached;
        return fetch(req).then((res) => {
          const copy = res.clone();
          caches.open(CACHE_NAME).then((cache) => cache.put(APP_SHELL_URL, copy));
          return res;
        });
      })
    );
    return;
  }

  // Librairies externes figées par version : cache d'abord (elles ne
  // changent jamais), réseau seulement si elles ne sont pas encore en
  // cache (ex. tout premier lancement, avant que l'install ait fini).
  if (LIB_FILES.includes(req.url)) {
    event.respondWith(
      caches.match(req).then((cached) => {
        if (cached) return cached;
        return fetch(req).then((res) => {
          const copy = res.clone();
          caches.open(CACHE_NAME).then((cache) => cache.put(req, copy));
          return res;
        });
      })
    );
    return;
  }

  // Pour le reste de la coquille (manifest, icônes) : même principe,
  // cache d'abord, réseau seulement si absent du cache.
  const isShellAsset = SHELL_FILES.some((f) => req.url.endsWith(f.replace('./', '')));
  if (!isShellAsset) return;

  event.respondWith(
    caches.match(req).then((cached) => {
      if (cached) return cached;
      return fetch(req).then((res) => {
        const copy = res.clone();
        caches.open(CACHE_NAME).then((cache) => cache.put(req, copy));
        return res;
      });
    })
  );
});

// Rafraîchissement à la demande : la page envoie ce message quand on
// appuie sur "Actualiser". On re-télécharge la coquille et les libs en
// forçant le contournement du cache HTTP (cache: 'reload'), on remplace
// le contenu du cache du service worker, puis on prévient la page —
// c'est elle qui décide s'il faut recharger tout de suite ou juste
// profiter de la mise à jour à la prochaine ouverture.
self.addEventListener('message', (event) => {
  if (!event.data || event.data.type !== 'REFRESH_SHELL') return;

  event.waitUntil(
    caches.open(CACHE_NAME).then((cache) =>
      Promise.all(
        [...SHELL_FILES, ...LIB_FILES].map((url) =>
          fetch(url, { cache: 'reload' })
            .then((res) => cache.put(url, res))
            .catch((err) => {
              console.error('[SW] Échec du rafraîchissement de', url, err);
            })
        )
      )
    ).then(() => {
      if (event.source) event.source.postMessage({ type: 'SHELL_REFRESHED' });
    })
  );
});

