(function (global) {
  "use strict";

  function App() {
    var
      hapi,
      doc = global.document,
      console = global.console,
      main = doc.getElementById("opacity"),
      effects;

    if (global.gapi && global.gapi.hangout) {
      hapi = global.gapi.hangout;
    } else {
      console.log("Hangout API not found...");
      return;
    }

    function animate(effect_index) {
      var effect = effects[effect_index], step, elapsed, o, opacity, end;
      elapsed = (new Date()).getTime() - effect.timestamp;
      end = true;
      for (step = effect.animation.length - 1; step >= 0; step--) {
        if (effect.animation[step].timestamp <= elapsed) {
          end = effect.animation[step].end;
          break;
        }
      }
      if (end) {
        opacity = effect.animation[effect.animation.length - 1].start;
      } else {
        opacity = effect.animation[step].start + (elapsed - effect.animation[step].timestamp) * effect.animation[step].change;
      }

      opacity = Math.max(Math.min(opacity, 1), 0);

      for (o = 0; o < effect.overlays.length; o++) {
        effect.overlays[o].setOpacity(opacity);
      }

      if (!end) {
        global.requestAnimationFrame(function () {
          animate(effect_index);
        });
      } else {
        effect.running = false;
      }
    }

    function startEffect(e) {
      var
        effect_index = e.target.getAttribute("data-index"),
        effect = effects[effect_index],
        o;
      if (!!effect && !effect.running) {
        effect.running = true;
        for (o = 0; o < effect.overlays.length; o++) {
          effect.overlays[o].setOpacity(effect.animation[0].start);
          effect.overlays[o].setVisible(true);
        }
        effect.timestamp = (new Date()).getTime();
        global.requestAnimationFrame(function () {
          animate(effect_index);
        });
      }
    }

    function initialize() {
      var i, button;

      effects = [
        {
          "name": "lightning",
          "label": "Lightning",
          "overlays": [
            hapi.av.effects.createImageResource("https://hangout-apps.appspot.com/overlayopacity/lightning.jpg").createOverlay()
          ],
          "animation": [
            {"timestamp": 0, "start": 0, "change": 0.01},
            {"timestamp": 100, "start": 1, "change": -0.005},
            {"timestamp": 200, "start": 0.5, "change": 0.005},
            {"timestamp": 300, "start": 1, "change": -0.01},
            {"timestamp": 400, "start": 0, "end": true}
          ],
          "running": false,
          "progress": 0,
          "timestamp": 0
        },
        {
          "name": "eyes",
          "label": "Flashing Eyes",
          "overlays": [
            hapi.av.effects.createImageResource("https://hangout-apps.appspot.com/overlayopacity/redeye.png").createFaceTrackingOverlay({
              "trackingFeature": hapi.av.effects.FaceTrackingFeature.LEFT_EYE,
              "rotateWithFace": true,
              "scaleWithFace": true
            }),
            hapi.av.effects.createImageResource("https://hangout-apps.appspot.com/overlayopacity/redeye.png").createFaceTrackingOverlay({
              "trackingFeature": hapi.av.effects.FaceTrackingFeature.RIGHT_EYE,
              "rotateWithFace": true,
              "scaleWithFace": true
            })
          ],
          "animation": [
            {"timestamp": 0, "start": 0, "change": 0.004},
            {"timestamp": 200, "start": 0.8, "change": 0},
            {"timestamp": 400, "start": 0.8, "change": -0.004},
            {"timestamp": 600, "start": 0, "end": true}
          ],
          "running": false,
          "progress": 0,
          "timestamp": 0
        }
      ];

      for (i = 0; i < effects.length; i++) {
        button = doc.createElement("button");
        button.innerHTML = effects[i].label;
        button.setAttribute("data-index", i);
        main.appendChild(button);
        button.onclick = startEffect;
      }
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
