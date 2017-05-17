(function (global) {
  "use strict";

  function App() {
    var
      hapi,
      document = global.document,
      console = global.console,
      THREE = global.THREE,
      renderer,
      scene,
      camera,
      last_tick = new Date().getTime(),
      camera_tick = last_tick,
      update_tick = last_tick,
      update_interval = 100,
      camera_interval = 2000,
      ROT_90 = Math.PI / 2,
      speed = 1 / 2000,
      dif_x = speed, dif_y = speed, dif_z = speed,
      backgroundReplacement,
      backgroundResource;

    if (global.gapi && global.gapi.hangout) {
      hapi = global.gapi.hangout;
    } else {
      console.log("Hangout API not found...");
      return;
    }

    /*
     * Render & Animation loop
     */
    function tick() {
      var
        this_tick = new Date().getTime(),
        elapsed = this_tick - last_tick,
        oldResource;

      // TODO: animate camera
      camera.rotation.x += elapsed * dif_x;
      camera.rotation.y += elapsed * dif_y;
      camera.rotation.z += elapsed * dif_z;

      if (this_tick - update_tick > update_interval) {
        // Update background resource
        oldResource = backgroundResource;
        backgroundResource = hapi.av.effects.createImageResource(renderer.domElement.toDataURL("image/png"));
        backgroundReplacement.setImageResource(backgroundResource);
        if (!backgroundReplacement.isVisible()) {
          backgroundReplacement.setVisible(true);
        }
        if (!!oldResource) {
          oldResource.dispose();
        }
        update_tick = this_tick;
      }

      if (this_tick - camera_tick > camera_interval) {
        dif_x = Math.random() * speed;
        dif_y = Math.random() * speed;
        dif_z = Math.random() * speed;
        camera_tick = this_tick;
      }

      renderer.render(scene, camera);
      last_tick = this_tick;
      global.requestAnimationFrame(tick);
    }

    function initialize() {
      var room, tmp, i, colors = ["yellow", "red", "blue"], canvas, ctx, y, step, texture, material, mesh, size, half;

      room = document.getElementById("room")

      if (!global.WebGLRenderingContext) {
        room.innerHTML = "Sorry, a browser with WebGL support is required, try Chrome ;)";
        return;
      }

      renderer = new THREE.WebGLRenderer({preserveDrawingBuffer: true});
      renderer.setSize(300, 200);
      renderer.setClearColor(new THREE.Color(0x000000));
      renderer.setClearColor(new THREE.Color(0xCCCCCC));

      scene = new THREE.Scene();
      camera = new THREE.PerspectiveCamera(50, 3 / 2, 0.1, 10000);
      camera.position.x = 0;
      camera.position.y = 0;
      camera.position.z = 0;
      scene.add(camera);

      tmp = new THREE.AmbientLight(0x333333);
      scene.add(tmp);


      size = 256;
      half = size / 2
      // create wall textures
      for (i = 0; i < 3; i++) {
        canvas = document.getElementById("texture" + (i + 1));
        canvas.width = size;
        canvas.height = size;
        ctx = canvas.getContext("2d");
        ctx.fillStyle = "black";
        ctx.fillRect(0, 0, size, size);
        step = Math.floor(size / 50);
        ctx.strokeStyle = colors[i];
        ctx.lineWidth = 2;
        for (y = Math.floor(step / 2); y < size; y+= step) {
          ctx.beginPath();
          ctx.moveTo(0, y);
          ctx.lineTo(size, y);
          ctx.stroke();
          ctx.closePath();
        }
        texture = new THREE.Texture(canvas);
        texture.needsUpdate = true;
        material = new THREE.MeshBasicMaterial({map: texture});

        mesh = new THREE.Mesh(new THREE.PlaneGeometry(size, size), material);
        mesh.doubleSided = true;
        switch (i) {
          case 0:
            mesh.rotation.x = -ROT_90;
            mesh.position.y = -half;
            break;
          case 1:
            mesh.rotation.y = ROT_90;
            mesh.position.x = -half;
            break;
          case 2:
            mesh.rotation.y = 0;
            mesh.position.z = -half;
            break;
        }
        scene.add(mesh);

        mesh = new THREE.Mesh(new THREE.PlaneGeometry(size, size), material);
        mesh.doubleSided = true;
        switch (i) {
          case 0:
            mesh.rotation.x = ROT_90;
            mesh.position.y = half;
            break;
          case 1:
            mesh.rotation.y = -ROT_90;
            mesh.position.x = half;
            break;
          case 2:
            mesh.rotation.y = 2 * ROT_90;
            mesh.position.z = half;
            break;
        }
        scene.add(mesh);
      }

      room.appendChild(renderer.domElement);

      hapi.av.effects.requestBackgroundReplacementLock(function (success) {
        if (success) {
          console.log("Got BackgroundReplacementLock.");
          backgroundReplacement = hapi.av.effects.getBackgroundReplacement();
          backgroundReplacement.setAlphaThreshold(150);
          tick();
        } else {
          console.log("Requesting BackgroundReplacementLock failed.");
        }
      });
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
