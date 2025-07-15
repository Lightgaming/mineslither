'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"assets/AssetManifest.bin": "6f96b249428a875963aa3111725c00d8",
"assets/AssetManifest.bin.json": "0776660427829b7bb26c45ec11cc128f",
"assets/AssetManifest.json": "3e37df9cf8194314ed2c0f75ca98b5e2",
"assets/assets/images/0.png": "990add7b32330c617f907cc38ab8f453",
"assets/assets/images/1.png": "af80a54d3617d9e16d01d7af7e98494e",
"assets/assets/images/2.png": "36623dbe91a5169c5a30cdb9a1b277d5",
"assets/assets/images/3.png": "67a0a4037274af61e90e016d16c0463d",
"assets/assets/images/4.png": "6acd34e6cdbce2621875d48847cdec67",
"assets/assets/images/5.png": "2f92ee6ebf2616f1dc978678aafd44a6",
"assets/assets/images/6.png": "0f4754a2942a5409da347d84356ccce1",
"assets/assets/images/7.png": "6f7dd635ef39b35b81db7fa0da02c627",
"assets/assets/images/8.png": "8427990f903c1c75646b3696396689aa",
"assets/assets/images/bg.png": "ad195ddfbf95de42735b0c2794dfdc65",
"assets/assets/images/bomb.png": "3485824e8120bf824b1dd767316ac1b3",
"assets/assets/images/facingDown.png": "b8be3b835434ac9d15fc407b4bad30db",
"assets/assets/images/flagged.png": "f31e6c65b9b47999d6bb69ec6926ab56",
"assets/assets/sounds/background_music.mp3": "0204118eebce1accc29186adf038ebb3",
"assets/assets/sounds/click.wav": "21423e17236e2dea65b2466c7e0a3fa2",
"assets/assets/sounds/eat.wav": "3a060edde4f8ecdacd73aa1945d61137",
"assets/assets/sounds/game_over.wav": "96b30fd8077859a24a6fd76211114991",
"assets/assets/sounds/mine_explode.wav": "ba8fa1dde4019eb0f55058c6a4fd5e49",
"assets/assets/sounds/win.wav": "79d167ed4100d6aec3d25adefd845fd8",
"assets/FontManifest.json": "ec8a82ec184cf6cd45fbf68291b1fe6b",
"assets/fonts/MaterialIcons-Regular.otf": "8de62b50b56564d0d56efc55c8be7100",
"assets/NOTICES": "ec216abe5ce8923b01a5245616cea15c",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "33b7d9392238c04c131b6ce224e13711",
"assets/packages/flutter_donation_buttons/assets/coffee.png": "2159a0ac84d49abbdb353eaaf502eeb8",
"assets/packages/flutter_donation_buttons/assets/coffee2.png": "1446f4880b85af9912f34dd705a371f5",
"assets/packages/simple_icons/fonts/SimpleIcons.ttf": "429f4878395a78daa21abc07b2954fd9",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"canvaskit/canvaskit.js": "728b2d477d9b8c14593d4f9b82b484f3",
"canvaskit/canvaskit.js.symbols": "bdcd3835edf8586b6d6edfce8749fb77",
"canvaskit/canvaskit.wasm": "7a3f4ae7d65fc1de6a6e7ddd3224bc93",
"canvaskit/chromium/canvaskit.js": "8191e843020c832c9cf8852a4b909d4c",
"canvaskit/chromium/canvaskit.js.symbols": "b61b5f4673c9698029fa0a746a9ad581",
"canvaskit/chromium/canvaskit.wasm": "f504de372e31c8031018a9ec0a9ef5f0",
"canvaskit/skwasm.js": "ea559890a088fe28b4ddf70e17e60052",
"canvaskit/skwasm.js.symbols": "e72c79950c8a8483d826a7f0560573a1",
"canvaskit/skwasm.wasm": "39dd80367a4e71582d234948adc521c0",
"favicon.png": "5dcef449791fa27946b3d35ad8803796",
"flutter.js": "83d881c1dbb6d6bcd6b42e274605b69c",
"flutter_bootstrap.js": "8fd3e8bbe9cdc6916de2da93b11b6edd",
"icons/Icon-192.png": "ac9a721a12bbc803b44f645561ecb1e1",
"icons/Icon-512.png": "96e752610906ba2a93c65f8abe1645f1",
"icons/Icon-maskable-192.png": "c457ef57daa1d16f64b27b786ec2ea3c",
"icons/Icon-maskable-512.png": "301a7604d45b3e739efc881eb04896ea",
"index.html": "9c495fee28b29915bf9028b27561adf8",
"/": "9c495fee28b29915bf9028b27561adf8",
"main.dart.js": "33331e1c79f21f841abdfc5c4bbb8704",
"main.dart.mjs": "dc66a1af2ba1caea833a866665a82efa",
"main.dart.wasm": "c8c38ff168c54a0e8063a815980c529e",
"manifest.json": "53b62b538ee83eb0d20352ff4c86b668",
"version.json": "084943c8ad243722e3da4e353999cfb0"};
// The application shell files that are downloaded before a service worker can
// start.
const CORE = ["main.dart.js",
"main.dart.wasm",
"main.dart.mjs",
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
