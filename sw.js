// Service worker de la Partothèque — met en cache la coquille de l'app
// (HTML/manifest/icônes) pour qu'elle s'ouvre même sans réseau, ainsi
// que les librairies externes figées par version (pdf.js), sans
// lesquelles le lecteur de partitions ne peut pas s'afficher hors-ligne.
// Les PDF eux-mêmes sont gérés séparément côté page (IndexedDB), pas ici.

const CACHE_NAME = 'partotheque-shell-v9';

// La page HTML elle-même n'est plus un nom fixe ("index.html") : elle
// est mise en cache et servie sous son propre chemin exact au moment de
// la navigation (voir plus bas). Ça permet à index.html (production) et
// beta.html (test) de cohabiter proprement, chacun avec sa propre copie
// en cache, sans rien à changer ici quand tu passes de l'un à l'autre.
const SHELL_FILES = [
  './manifest.json',
  './manifest-beta.json',
  './icon-192.png',
  './icon-512.png',
  './icon-180.png',
  './icon-192-beta.png',
  './icon-512-beta.png',
  './icon-180-beta.png',
  './logo-header.png',
  './logo-header-beta.png',
  './fonts/fraunces-variable.woff2',
  './fonts/inter-variable.woff2',
  './fonts/ibmplexmono-regular.woff2',
  './fonts/ibmplexmono-medium.woff2',
];

// Librairies externes chargées depuis une CDN, figées par un numéro de
// version dans leur URL — leur contenu ne changera donc jamais tant que
// les <script> de index.html pointent vers ces mêmes versions, ce qui
// permet un cache "à vie" sans risque de servir une version périmée.
// ⚠️ Si tu changes une de ces versions dans index.html, mets-la à jour
// ici aussi, sinon l'ancienne version restera servie depuis le cache.
// C'est important pour la vitesse de chargement, pas seulement pour le
// mode hors-ligne : ce sont des <script> bloquants dans le <head> — tant
// qu'ils ne sont pas chargés, toute la page reste suspendue. En mauvaise
// couverture (contrairement au mode avion, qui échoue tout de suite),
// une requête réseau peut traîner très longtemps avant d'aboutir ou
// d'échouer, d'où la lenteur si elles ne sont pas servies depuis le
// cache.
const LIB_FILES = [
  'https://cdnjs.cloudflare.com/ajax/libs/pdf.js/3.11.174/pdf.min.js',
  'https://cdnjs.cloudflare.com/ajax/libs/pdf.js/3.11.174/pdf.worker.min.js',
  'https://www.gstatic.com/firebasejs/10.13.2/firebase-app-compat.js',
  'https://www.gstatic.com/firebasejs/10.13.2/firebase-firestore-compat.js',
];

// Dernier recours absolu : si on est hors-ligne ET que rien n'est en
// cache pour cette page précise (ex. tout premier lancement de ce
// device fait sans réseau, ou URL jamais visitée avant), on affiche ce
// mini message plutôt que de laisser Safari planter avec une erreur
// technique brute ("FetchEvent.respondWith received an error...").
function offlineFallbackPage() {
  return new Response(
    `<!DOCTYPE html><html lang="fr"><head><meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Hors ligne — Partothèque</title>
<style>
  body { margin:0; min-height:100vh; display:flex; align-items:center;
         justify-content:center; padding:32px; box-sizing:border-box;
         background:#15122E; color:#fff; font-family:-apple-system,
         BlinkMacSystemFont,'Segoe UI',sans-serif; text-align:center; }
  div { max-width:320px; }
  h1 { font-size:19px; margin:0 0 12px; }
  p { color:#B8B2A8; line-height:1.5; font-size:14px; margin:0; }
</style></head><body><div>
  <h1>Hors ligne</h1>
  <p>Cette page n'a pas encore été enregistrée sur cet appareil.
  Connecte-toi une première fois (wifi ou données mobiles) pour
  qu'elle fonctionne ensuite sans réseau.</p>
</div></body></html>`,
    { status: 200, headers: { 'Content-Type': 'text/html; charset=utf-8' } }
  );
}

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
  // d'un timeout réseau). On met en cache et on sert sous le chemin
  // exact demandé (ex. /index.html ou /beta.html), sans paramètres —
  // index.html et beta.html ont donc chacun leur propre copie en cache,
  // indépendante. Le réseau n'est utilisé que si rien n'est encore en
  // cache pour ce chemin précis (tout premier lancement de cette page) ;
  // ensuite, la mise à jour ne se fait que via le bouton "Actualiser"
  // (message REFRESH_SHELL plus bas), pas automatiquement à chaque
  // ouverture.
  if (req.mode === 'navigate') {
    // Un site servi à la racine (ex. bandaesperanza.github.io/) envoie
    // une navigation vers "/", pas "/index.html" — on traite les deux
    // comme la même page pour éviter que le cache les considère comme
    // deux entrées différentes selon la façon dont l'app a été ouverte.
    const url = new URL(req.url);
    const pageKey = url.pathname.endsWith('/') ? url.pathname + 'index.html' : url.pathname;
    event.respondWith(
      caches.match(pageKey).then((cached) => {
        if (cached) return cached;
        return fetch(req).then((res) => {
          const copy = res.clone();
          caches.open(CACHE_NAME).then((cache) => cache.put(pageKey, copy));
          return res;
        });
      }).catch(() => offlineFallbackPage())
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
      }).catch(() => new Response('', { status: 504, statusText: 'Hors ligne' }))
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
    }).catch(() => new Response('', { status: 504, statusText: 'Hors ligne' }))
  );
});

// Rafraîchissement à la demande : la page envoie ce message quand on
// appuie sur "Actualiser". On re-télécharge la coquille partagée, les
// libs, et la page HTML d'où vient la demande (index.html ou beta.html,
// peu importe) en forçant le contournement du cache HTTP (cache:
// 'reload'), on remplace le contenu du cache du service worker, puis on
// prévient la page — c'est elle qui décide s'il faut recharger tout de
// suite ou juste profiter de la mise à jour à la prochaine ouverture.
self.addEventListener('message', (event) => {
  if (!event.data || event.data.type !== 'REFRESH_SHELL') return;

  const pageKey = (() => {
    if (!event.source) return null;
    const url = new URL(event.source.url);
    return url.pathname.endsWith('/') ? url.pathname + 'index.html' : url.pathname;
  })();
  const targets = pageKey ? [...SHELL_FILES, ...LIB_FILES, pageKey] : [...SHELL_FILES, ...LIB_FILES];

  event.waitUntil(
    caches.open(CACHE_NAME).then((cache) =>
      Promise.all(
        targets.map((url) =>
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

