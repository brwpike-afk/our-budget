// Minimal service worker — just enough so iOS treats this as an installable app.
// It does not cache aggressively, so you always get the latest version.
self.addEventListener('install', () => self.skipWaiting());
self.addEventListener('activate', () => self.clients.claim());
self.addEventListener('fetch', () => {});
