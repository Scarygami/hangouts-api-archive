(function (global) {
  "use strict";

  function App() {
    var
      hapi,
      document = global.document,
      console = global.console,
      mainDiv, picker, video, controls, current, slider, auto, token, parent,
      backgroundReplacement,
      backgroundResource;

    if (global.gapi && global.gapi.hangout) {
      hapi = global.gapi.hangout;
    } else {
      console.log("Hangout API not found...");
      return;
    }

    function getParameter(paramName, query) {
      var searchString = query || global.location.search.substring(1),
      i, val, params = searchString.split('&');

      for (i = 0; i < params.length; i++) {
        val = params[i].split('=');
        if (val[0] == paramName) {
          return unescape(val[1]);
        }
      }
      return null;
    }

    function repositionVideo() {
      var
        width = document.body.offsetWidth - mainDiv.offsetWidth,
        height = document.body.offsetHeight,
        left = mainDiv.offsetLeft + mainDiv.offsetWidth,
        top = document.body.offsetTop,
        aspect = video.getAspectRatio(),
        videoWidth, videoHeight, videoTop, videoLeft;

      videoWidth = width * 0.98;
      videoHeight = videoWidth / aspect;
      if (videoHeight > height * 0.99) {
        videoHeight = height * 0.99;
        videoWidth = videoHeight * aspect;
      }
      videoTop = top + (height - videoHeight) / 2;
      videoLeft = left + (width - videoWidth) / 2;

      video.setPosition(videoLeft, videoTop);
      video.setWidth(videoWidth);
    }

    function updateBackground(url) {
      if (!!backgroundResource && !backgroundResource.isDisposed()) {
        backgroundResource.dispose();
      }
      backgroundResource = hapi.av.effects.createImageResource(url);
      backgroundReplacement = hapi.av.effects.getBackgroundReplacement();
      backgroundReplacement.setImageResource(backgroundResource);
      backgroundReplacement.setAlphaThreshold(parseInt(slider.value, 10));
      backgroundReplacement.setAlphaThresholdAutoUpdating(auto.checked);
      if (!backgroundReplacement.isVisible()) {
        backgroundReplacement.setVisible(true);
      }
      current.src = url.replace("/s1000/", "/s300/");
      controls.style.display = "block";
    }

    function pickerCallback(data) {
      var url;
      console.log(data);
      if (data.action == "cancel") {
        video.setVisible(true);
        return;
      }
      if (data.action == "picked") {
        video.setVisible(true);
        if (data.docs && data.docs.length > 0 && data.docs[0].thumbnails && data.docs[0].thumbnails.length > 0) {
          url = data.docs[0].thumbnails[0].url.replace("/s32-c/", "/s1000/");
          if (hapi.av.effects.hasBackgroundReplacementLock()) {
            updateBackground(url);
          } else {
            hapi.av.effects.requestBackgroundReplacementLock(function (success) {
              if (success) {
                updateBackground(url);
              } else {
                console.log("Couldn't get Background replacement lock.");
              }
            });
          }
        }
      }
    }

    function initialize() {
      console.log("Picker library loaded.");
      mainDiv = document.getElementById("background");
      controls = document.getElementById("controls");
      slider = document.getElementById("alpha");
      auto = document.getElementById("auto");
      controls.style.display = "none";
      current = document.getElementById("current");

      video = hapi.layout.getVideoCanvas();
      video.setVideoFeed(hapi.layout.createParticipantVideoFeed(hapi.getLocalParticipantId()));
      repositionVideo();
      video.setVisible(true);

      // Extract token forwarded from iframer
      token = getParameter('token');

      // Extract top window location from iframer
      parent = getParameter('parent');
      parent = getParameter('parent', parent);

      picker = new global.google.picker.PickerBuilder()
          .addView(new global.google.picker.PhotosView())
          .addView(new global.google.picker.View(global.google.picker.ViewId.PHOTO_UPLOAD))
          .setOrigin(parent)
          .setOAuthToken(token)
          .setDeveloperKey("AIzaSyAFP5Av3xkZWoDZ5_62uM5Jyue8ES4FvGY")
          .setCallback(pickerCallback)
          .build();

      global.onresize = repositionVideo;
      document.getElementById("pick").onclick = function () {
        video.setVisible(false);
        picker.setVisible(true);
      };

      document.getElementById("hide").onclick = function () {
        if (hapi.av.effects.hasBackgroundReplacementLock()) {
          if (!!backgroundReplacement) {
            backgroundReplacement.setVisible(false);
          }
          hapi.av.effects.releaseBackgroundReplacementLock();
        }
        controls.style.display = "none";
      };

      slider.onchange = function () {
        if (!!backgroundReplacement && hapi.av.effects.hasBackgroundReplacementLock()) {
          backgroundReplacement.setAlphaThreshold(parseInt(slider.value, 10));
        }
      };

      auto.onclick = function () {
        if (auto.checked) {
          slider.style.visibility = "hidden";
          if (!!backgroundReplacement && hapi.av.effects.hasBackgroundReplacementLock()) {
            backgroundReplacement.setAlphaThresholdAutoUpdating(true);
          }
        } else {
          slider.style.visibility = "visible";
          if (!!backgroundReplacement && hapi.av.effects.hasBackgroundReplacementLock()) {
            backgroundReplacement.setAlphaThresholdAutoUpdating(false);
            backgroundReplacement.setAlphaThreshold(parseInt(slider.value, 10));
          }
        }
      };
    }

    hapi.onApiReady.add(function (e) {
      if (e.isApiReady) {
        console.log("Hangout API ready!");
        global.google.load("picker", "1", {"callback": initialize});
      }
    });
  }

  global.hangoutapp = new App();

}(this));
