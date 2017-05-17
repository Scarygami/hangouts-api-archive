(function (global) {
  "use strict";

  function App() {
    var
      hapi,
      document = global.document,
      console = global.console,
      debug = document.getElementById("debug"),
      overlay;
    
    if (global.gapi && global.gapi.hangout) {
      hapi = global.gapi.hangout;
    } else {
      console.log("Hangout API not found...");
      return;
    }

    function handtracking(data) {
      if (data.hasHand) {
        debug.innerHTML = JSON.stringify(data.hands, undefined, "  ");
        overlay.setVisible(true);
      } else {
        overlay.setVisible(false);
      }
    }

    function initialize() {
      var resource = hapi.av.effects.createImageResource("https://hangout-apps.appspot.com/handtracking/coin.png");
      overlay = resource.createHandTrackingOverlay({
        trackingFeature: hapi.av.effects.HandTrackingFeature.HAND_CENTER,
        offset: {x: 0, y: 0.1},
        scale: 0.5,
        scaleWithHand: false});
      hapi.av.effects.onHandTrackingDataChanged.add(handtracking);
    }

    hapi.onApiReady.add(function (e) {
      if (e.isApiReady) {
        console.log("Hangout API ready!");
        global.setTimeout(initialize, 1);
      }
    });
  }

  global.hangoutapp = new App();

}(this));
