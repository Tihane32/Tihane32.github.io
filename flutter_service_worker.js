'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"assets/AssetManifest.bin": "800c10c2adee9a1a575ee5aca1fa33d0",
"assets/AssetManifest.bin.json": "d133ff3a26f69a9015214b1a530a8533",
"assets/AssetManifest.json": "3b76f2ecf2cb4b6bd5670b2245282e5f",
"assets/assets/aku1.jpg": "7855edc7107f46dc9c083c6b673f95ed",
"assets/assets/appIcons/DSM_icon_V1.png": "90cce156f62d4b3b02b82f3b65a21080",
"assets/assets/appIcons/DSM_icon_V2.png": "2d34e7d5d95d47df78a3f85e63095fc4",
"assets/assets/boiler1.jpg": "097f455b22be3221b0f6988a82e45c7b",
"assets/assets/boiler33.jpg": "658395b2ebb9026d788e7c7eeb0ebdbe",
"assets/assets/elektriauto55.jpg": "b2e25484809fae638113d647dcb733a0",
"assets/assets/elektriautoVahur.jpg": "822692c499bf3bdd7fa9a3bef64b9052",
"assets/assets/icon_boiler.png": "0fa4bfc0292b93a5814f0fa2bb6dd22a",
"assets/assets/icon_elektriauto.png": "d3947f796707dbdb1c2be9d29a6bb00d",
"assets/assets/icon_elektriautoLaadia.png": "f01703e723872075cbf17ee2bc5938ea",
"assets/assets/icon_noudepesumasin.png": "c2e6b18712d106e65d3b76c922d5f8c6",
"assets/assets/icon_pesumasin.png": "594096cc1ecd1e4faa16aa736c928c88",
"assets/assets/icon_sensor.png": "19e68a6a1d2a786db9b761c6a1b2b657",
"assets/assets/icon_smartSocket.jpg": "a8a077b1e93b102caa530c203834ca14",
"assets/assets/icon_toukeratas.png": "2f264e47d80b2729215aa78821e834b8",
"assets/assets/kuivati1.jpg": "e2b01957c3cb4ee5c979feb37b81da23",
"assets/assets/kuivati2.jpg": "776e60eb7eb4d72ec827e5315ceafa03",
"assets/assets/MitsubishiIMiEv1.jpg": "2b66e7b97064152b3eb8b9fcf452c38c",
"assets/assets/n%25C3%25B5udepesumasin2.jpg": "487120d742da50ae910948ed27fb8d20",
"assets/assets/noudepesumasin1.jpg": "06d0d9a1d70475c103e0dfe53c828044",
"assets/assets/pesumasin1.png": "01a51ce11ef818ed8d41c79b9fa7241e",
"assets/assets/pesumasin2.jpg": "26138c16abc78a3535506c468b33f27e",
"assets/assets/pump1.jpg": "eb3d3d31f47ed1d81fe3efdcc91a8e50",
"assets/assets/saun1.jpg": "53f1e2c19415e5dc5463e18b3c7577ae",
"assets/assets/ShellyConf.csv": "834a7a67c94ad49c03328a405c70a75e",
"assets/assets/TeslaModel31.jpg": "d5d50875bbae0fb19736c761dfc92b58",
"assets/assets/trakkodu.jpg": "022363d0ac5862f08d0f73ad12ec172b",
"assets/assets/tuulik.jpg": "e344be40430b67ad97c40e8e44e49aef",
"assets/assets/tuulik2.jpg": "0d9a488c880ad7954c36db456b481db3",
"assets/assets/tuulik3.jpg": "beca039be7d46bd35dcdba09455a53a1",
"assets/assets/tuulik4.jpg": "f08aa5afad803396fbab1bb86aaed285",
"assets/assets/tuulik5.jpg": "0ccb31b4e73385c04f8896289d7066c7",
"assets/assets/tuulik7.jpg": "f8d2aef1631078da683803f26109dd71",
"assets/assets/tuulik8.jpg": "4b2c6d574dbea6ef3f04a041f824bf10",
"assets/assets/valge.png": "b23336b4eab8d498fb59617a3dc4def4",
"assets/assets/verandaLamp1.png": "7610738c85e9a195c0e3e2b21fce4800",
"assets/assets/vesinik1.jpg": "8b424f24f4901ba37cc3c093d4282d85",
"assets/FontManifest.json": "6a84e6c28a318c1ef29352d8cf66d39c",
"assets/fonts/MaterialIcons-Regular.otf": "490968d670bb8276ea45c2f6d602d55e",
"assets/NOTICES": "bad6a76d0d94db90acbed7ad5cbda979",
"assets/packages/awesome_notifications/test/assets/images/test_image.png": "c27a71ab4008c83eba9b554775aa12ca",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "e986ebe42ef785b27164c36a9abc7818",
"assets/packages/font_awesome_flutter/lib/fonts/fa-brands-400.ttf": "17ee8e30dde24e349e70ffcdc0073fb0",
"assets/packages/font_awesome_flutter/lib/fonts/fa-regular-400.ttf": "f3307f62ddff94d2cd8b103daf8d1b0f",
"assets/packages/font_awesome_flutter/lib/fonts/fa-solid-900.ttf": "04f83c01dded195a11d21c2edf643455",
"assets/packages/material_design_icons_flutter/lib/fonts/materialdesignicons-webfont.ttf": "3759b2f7a51e83c64a58cfe07b96a8ee",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"canvaskit/canvaskit.js": "66177750aff65a66cb07bb44b8c6422b",
"canvaskit/canvaskit.js.symbols": "48c83a2ce573d9692e8d970e288d75f7",
"canvaskit/canvaskit.wasm": "1f237a213d7370cf95f443d896176460",
"canvaskit/chromium/canvaskit.js": "671c6b4f8fcc199dcc551c7bb125f239",
"canvaskit/chromium/canvaskit.js.symbols": "a012ed99ccba193cf96bb2643003f6fc",
"canvaskit/chromium/canvaskit.wasm": "b1ac05b29c127d86df4bcfbf50dd902a",
"canvaskit/skwasm.js": "694fda5704053957c2594de355805228",
"canvaskit/skwasm.js.symbols": "262f4827a1317abb59d71d6c587a93e2",
"canvaskit/skwasm.wasm": "9f0c0c02b82a910d12ce0543ec130e60",
"canvaskit/skwasm.worker.js": "89990e8c92bcb123999aa81f7e203b1c",
"favicon.png": "82990f771a4da2dddba3aefdf7a5722f",
"flutter.js": "f393d3c16b631f36852323de8e583132",
"flutter_bootstrap.js": "6dc694548331c60e2e365afa4966ee99",
"icons/Icon-192.png": "ae5b969da0cb25c13e46b8049b6fafad",
"icons/Icon-512.png": "939c72c1dbe6b0342aef6a4195019d75",
"icons/Icon-maskable-192.png": "ae5b969da0cb25c13e46b8049b6fafad",
"icons/Icon-maskable-512.png": "939c72c1dbe6b0342aef6a4195019d75",
"index.html": "713d2dbb8405449a6d9efbae01510fca",
"/": "713d2dbb8405449a6d9efbae01510fca",
"main.dart.js": "332bca20207558f95258b2ba3d0ffecd",
"manifest.json": "492bfdc1bfa3bf28b12d7280f8c551a5",
"version.json": "3aff06b492c84b559925db0ef42c4dc4"};
// The application shell files that are downloaded before a service worker can
// start.
const CORE = ["main.dart.js",
"index.html",
"flutter_bootstrap.js",
"assets/AssetManifest.bin.json",
"assets/FontManifest.json"];

// During install, the TEMP cache is populated with the application shell files.
self.addEventListener("install", (event) => {
  self.skipWaiting();
  return event.waitUntil(
    caches.open(TEMP).then((cache) => {
      return cache.addAll(
        CORE.map((value) => new Request(value, {'cache': 'reload'})));
    })
  );
});
// During activate, the cache is populated with the temp files downloaded in
// install. If this service worker is upgrading from one with a saved
// MANIFEST, then use this to retain unchanged resource files.
self.addEventListener("activate", function(event) {
  return event.waitUntil(async function() {
    try {
      var contentCache = await caches.open(CACHE_NAME);
      var tempCache = await caches.open(TEMP);
      var manifestCache = await caches.open(MANIFEST);
      var manifest = await manifestCache.match('manifest');
      // When there is no prior manifest, clear the entire cache.
      if (!manifest) {
        await caches.delete(CACHE_NAME);
        contentCache = await caches.open(CACHE_NAME);
        for (var request of await tempCache.keys()) {
          var response = await tempCache.match(request);
          await contentCache.put(request, response);
        }
        await caches.delete(TEMP);
        // Save the manifest to make future upgrades efficient.
        await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
        // Claim client to enable caching on first launch
        self.clients.claim();
        return;
      }
      var oldManifest = await manifest.json();
      var origin = self.location.origin;
      for (var request of await contentCache.keys()) {
        var key = request.url.substring(origin.length + 1);
        if (key == "") {
          key = "/";
        }
        // If a resource from the old manifest is not in the new cache, or if
        // the MD5 sum has changed, delete it. Otherwise the resource is left
        // in the cache and can be reused by the new service worker.
        if (!RESOURCES[key] || RESOURCES[key] != oldManifest[key]) {
          await contentCache.delete(request);
        }
      }
      // Populate the cache with the app shell TEMP files, potentially overwriting
      // cache files preserved above.
      for (var request of await tempCache.keys()) {
        var response = await tempCache.match(request);
        await contentCache.put(request, response);
      }
      await caches.delete(TEMP);
      // Save the manifest to make future upgrades efficient.
      await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
      // Claim client to enable caching on first launch
      self.clients.claim();
      return;
    } catch (err) {
      // On an unhandled exception the state of the cache cannot be guaranteed.
      console.error('Failed to upgrade service worker: ' + err);
      await caches.delete(CACHE_NAME);
      await caches.delete(TEMP);
      await caches.delete(MANIFEST);
    }
  }());
});
// The fetch handler redirects requests for RESOURCE files to the service
// worker cache.
self.addEventListener("fetch", (event) => {
  if (event.request.method !== 'GET') {
    return;
  }
  var origin = self.location.origin;
  var key = event.request.url.substring(origin.length + 1);
  // Redirect URLs to the index.html
  if (key.indexOf('?v=') != -1) {
    key = key.split('?v=')[0];
  }
  if (event.request.url == origin || event.request.url.startsWith(origin + '/#') || key == '') {
    key = '/';
  }
  // If the URL is not the RESOURCE list then return to signal that the
  // browser should take over.
  if (!RESOURCES[key]) {
    return;
  }
  // If the URL is the index.html, perform an online-first request.
  if (key == '/') {
    return onlineFirst(event);
  }
  event.respondWith(caches.open(CACHE_NAME)
    .then((cache) =>  {
      return cache.match(event.request).then((response) => {
        // Either respond with the cached resource, or perform a fetch and
        // lazily populate the cache only if the resource was successfully fetched.
        return response || fetch(event.request).then((response) => {
          if (response && Boolean(response.ok)) {
            cache.put(event.request, response.clone());
          }
          return response;
        });
      })
    })
  );
});
self.addEventListener('message', (event) => {
  // SkipWaiting can be used to immediately activate a waiting service worker.
  // This will also require a page refresh triggered by the main worker.
  if (event.data === 'skipWaiting') {
    self.skipWaiting();
    return;
  }
  if (event.data === 'downloadOffline') {
    downloadOffline();
    return;
  }
});
// Download offline will check the RESOURCES for all files not in the cache
// and populate them.
async function downloadOffline() {
  var resources = [];
  var contentCache = await caches.open(CACHE_NAME);
  var currentContent = {};
  for (var request of await contentCache.keys()) {
    var key = request.url.substring(origin.length + 1);
    if (key == "") {
      key = "/";
    }
    currentContent[key] = true;
  }
  for (var resourceKey of Object.keys(RESOURCES)) {
    if (!currentContent[resourceKey]) {
      resources.push(resourceKey);
    }
  }
  return contentCache.addAll(resources);
}
// Attempt to download the resource online before falling back to
// the offline cache.
function onlineFirst(event) {
  return event.respondWith(
    fetch(event.request).then((response) => {
      return caches.open(CACHE_NAME).then((cache) => {
        cache.put(event.request, response.clone());
        return response;
      });
    }).catch((error) => {
      return caches.open(CACHE_NAME).then((cache) => {
        return cache.match(event.request).then((response) => {
          if (response != null) {
            return response;
          }
          throw error;
        });
      });
    })
  );
}
