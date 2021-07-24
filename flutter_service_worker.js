'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';
const RESOURCES = {
  "favicon.png": "6e139f5da5e7e7d907b86b14af5031a7",
"main.dart.js": "94d30f08546a1f4e4329190b83ec8284",
"index.html": "9ae64f555d5172584eda51f8acf68359",
"/": "9ae64f555d5172584eda51f8acf68359",
"manifest.json": "943a1b980a88e0083c53e9771dfa2031",
"assets/images/researcher_images/researcher_dashboard/researcher_thoughtnav_logo.png": "c7b28da9209cd95b11b0c3ff7c81999a",
"assets/images/researcher_images/researcher_dashboard/participant_icon.png": "54073bb9d9536a3800096168015797ba",
"assets/images/researcher_images/researcher_dashboard/researcher_avatar.png": "8170f5520d1425dd1e5e67001764e60a",
"assets/images/questions_icons/comment_icon.png": "fde47d380f40bf44a79b3d570ec1ad53",
"assets/images/questions_icons/quick_intro_complete_icon.png": "36e4552580e19ceb6a1e00d7078545d5",
"assets/images/questions_icons/clap_icon.png": "bb07564427a0c641252b0abe9f4f3dae",
"assets/images/dashboard_icons/contact_us.png": "41bf3738fe07e043d91551d04cea04ec",
"assets/images/dashboard_icons/dashboard.png": "a85b312cce8e2804e9e29f984edfc18d",
"assets/images/dashboard_icons/preferences.png": "465ab1057313caec01aa058986020f95",
"assets/images/dashboard_icons/notifications_outline_black.png": "237112ac3a2161744eb249e1924a8a12",
"assets/images/dashboard_icons/rewards.png": "62a1b2e724bffec41302d1cebe7e9b28",
"assets/images/homescreen_images/3.png": "ef24b42570572cca548609e8f8742814",
"assets/images/homescreen_images/1.png": "57d76f652982c1ed780c6457f5b3deee",
"assets/images/homescreen_images/2.png": "1711690f4209ea5a1e952c5428a17858",
"assets/images/amazon_a_logo.png": "1dc6f2ed0ce92aeca8b33d96a86d21d5",
"assets/images/amazon_logo.png": "f39942a6438ad4105bb1006d72ff0cc9",
"assets/images/login_section_images/login_button_icon.png": "82d1b6a9c540e59bdfa976ee095e54b4",
"assets/images/paypal_logo.png": "90064d5f7d7e2a9c3356c035658ffaa0",
"assets/images/login_screen_right.png": "3ca4cacbfe234c8b2885044d1e4e578a",
"assets/images/login_screen_left.png": "9d476c2ccaae618ad45ea5a87e902209",
"assets/images/svg_icons/message_icon.png": "3676bd6a5f5b49fa2d379b133729630e",
"assets/images/svg_icons/dollar.png": "9c793869d7fda9ab8927b6c36a23adf1",
"assets/images/svg_icons/calender_icon.png": "03b9ca10bcfbaab48ac94a58cf114933",
"assets/images/svg_icons/amazon_icon.png": "120552613d1054424b50aa9da1eb8708",
"assets/images/svg_icons/gift_card.png": "de756526a96cb0d6baf9dd929478f6ef",
"assets/images/svg_icons/checkbox_icon.png": "8733b98557bd9cf0db6ed66348c52497",
"assets/images/dashboard_screen_3.png": "cf1412f64322442db74b6d3afd60de12",
"assets/images/set_account_icons/send_message_icon.png": "cfb59a03de589fea5c23ba3b02de363c",
"assets/images/set_account_icons/white_shirt_woman.png": "e91d57cc40410ff64f5a6bc4348e3284",
"assets/images/set_account_icons/blue_shirt_man.png": "969fb5208d83183375cca741424b92a1",
"assets/images/set_account_icons/light_blue_jacket_man.png": "b8c0aad83716a8e857cb79435b4621a1",
"assets/images/set_account_icons/red_jacket_woman.png": "02903f493213f6fbda8ad67c32ba3603",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "b14fcf3ee94e3ace300b192e9e7c8c5d",
"assets/packages/flutter_widget_from_html_core/test/images/logo.png": "57838d52c318faff743130c3fcfae0c6",
"assets/packages/flutter_markdown/assets/logo.png": "67642a0b80f3d50277c44cde8f450e50",
"assets/packages/wakelock_web/assets/no_sleep.js": "7748a45cd593f33280669b29c2c8919a",
"assets/NOTICES": "1b238050a918b835d96eb85b9fedbbbb",
"assets/FontManifest.json": "61541eb69e517ffcfb42fb187555df05",
"assets/fonts/MaterialIcons-Regular.otf": "1288c9e28052e028aba623321f7826ac",
"assets/assets/fonts/sofia_pro_regular.otf": "a7a07e7f06f7f684948562bb2e7d1cbd",
"assets/AssetManifest.json": "e4a8013dee4e3c610b548eab2947d4dc",
"quill.js": "b0b128e4501b62cd9317a9662f54a863",
"version.json": "6a7967e79a9f9c344e867ae00f4715b6",
"icons/Icon-192.png": "0ed80c5889a7c4e91a81b14864c8364c",
"icons/Icon-512.png": "b42758763358919bb47fde33d860650c",
"quill.html": "22925429cf86ad199800552b71384538"
};

// The application shell files that are downloaded before a service worker can
// start.
const CORE = [
  "/",
"main.dart.js",
"index.html",
"assets/NOTICES",
"assets/AssetManifest.json",
"assets/FontManifest.json"];
// During install, the TEMP cache is populated with the application shell files.
self.addEventListener("install", (event) => {
  self.skipWaiting();
  return event.waitUntil(
    caches.open(TEMP).then((cache) => {
      return cache.addAll(
        CORE.map((value) => new Request(value + '?revision=' + RESOURCES[value], {'cache': 'reload'})));
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
        // lazily populate the cache.
        return response || fetch(event.request).then((response) => {
          cache.put(event.request, response.clone());
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
