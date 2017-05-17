(function (global) {

  var
    hapi = global.gapi.hangout,
    metaEffect, basicChain, positions, empty,
    gridSize = 4, videoCanvas, videoFeed, participants, participantId, myId;

  function createBasicChain() {
    var x, y;

    basicChain = [];

    for (x = 0; x < gridSize; x++) {
      for (y = 0; y < gridSize; y++) {
        basicChain.push(
          metaEffect.createSubEffect('copy', {resource_key: 'r' + (y * gridSize + x)})
        );
        basicChain.push(
          metaEffect.createSubEffect('crop', {
            height: 1 / gridSize,
            width: 1 / gridSize,
            top_left: {x: x / gridSize, y: y / gridSize}
          })
        );
        basicChain.push(
          metaEffect.createSubEffect('swap', {resource_key: 'r' + (y * gridSize + x)})
        );
      }
    }
    basicChain.push(
      metaEffect.createSubEffect('grayscale', {})
    );
    basicChain.push(
      metaEffect.createSubEffect('simple_bcs', {
        brightness: -1,
        contrast: 0,
        saturation: 0
      })
    );
    basicChain.push(
      metaEffect.createSubEffect('simple_bcs', {
        brightness: -1,
        contrast: 0,
        saturation: 0
      })
    );
  }

  function getFullChain() {
    var effectChain = basicChain.slice(0), x, y, pos;

    for (x = 0; x < gridSize; x++) {
      for (y = 0; y < gridSize; y++) {
        pos = positions[y * gridSize + x];
        if (pos !== (gridSize * gridSize - 1)) {
          effectChain.push(
            metaEffect.createSubEffect('static_overlay', {
              resource: {key: 'r' + pos},
              scale: 1,
              h_align: -x,
              v_align: -y
            })
          );
        }
      }
    }

    return effectChain;
  }

  function show() {
    var chain = getFullChain();
    metaEffect.initEffects(chain);
    metaEffect.pipelineEffects(chain);
  }

  function move(dx, dy, id) {
    id = id || participantId;
    if (id == myId) {
      if (empty.x + dx >= 0 && empty.x + dx < gridSize && empty.y + dy >= 0 && empty.y + dy < gridSize) {
        positions[empty.x  + empty.y * gridSize] = positions[empty.x  + dx + (empty.y + dy) * gridSize];
        positions[empty.x  + dx + (empty.y + dy) * gridSize] = gridSize * gridSize - 1;
        empty.x += dx;
        empty.y += dy;
        show();
      }
    } else {
      hapi.data.sendMessage(JSON.stringify({
        participant: id,
        dx: dx,
        dy: dy
      }));
    }
  }

  function shuffle(id) {
    var
      dirs = [{dx: 0, dy: 1}, {dx: 1, dy: 0}, {dx: 0, dy: -1}, {dx: -1, dy: 0}],
      count, dir;

    id = id || participantId;

    for (count = 0; count < 100; count++) {
      dir = dirs[Math.floor(Math.random()* 4)];
      move(dir.dx, dir.dy, id);
    }
  }

  function solve() {
    var i;
    positions = [];
    for (i = 0; i < gridSize * gridSize; i++) {
      positions[i] = i;
    }
    empty = {x: gridSize - 1, y: gridSize - 1};
    show();
  }

  function chooseTarget() {
    participants = hapi.getEnabledParticipants().map(function (p) { return p.id; });
    participants = participants.filter(function (p) { return (p != myId); });
    if (!participantId || participants.indexOf(participantId) < 0) {
      if (participants.length > 0) {
        participantId = participants[Math.floor(Math.random() * participants.length)];
      } else {
        participantId = myId;
      }
      hapi.layout.getDefaultVideoFeed().setDisplayedParticipant(participantId);
      videoFeed = hapi.layout.createParticipantVideoFeed(participantId);
      videoCanvas.setVideoFeed(videoFeed);
    }
  }

  function start() {
    var canvas;

    myId = hapi.getLocalParticipantId();

    metaEffect = hapi.av.effects.createMetaEffect();
    createBasicChain();

    global.document.getElementById("shuffle").onclick = function () {
      shuffle();
    };
    global.document.getElementById("up").onclick = function () {
      move(0, 1);
    };
    global.document.getElementById("down").onclick = function () {
      move(0, -1);
    };
    global.document.getElementById("left").onclick = function () {
      move(-1, 0);
    };
    global.document.getElementById("right").onclick = function () {
      move(1, 0);
    };

    global.onkeydown = function (e) {
      var key = e.code || e.keyCode || e.which;
      switch (key) {
        case 37:
          move(-1, 0);
          break;
        case 38:
          move(0, 1);
          break;
        case 39:
          move(1, 0);
          break;
        case 40:
          move(0, -1);
          break;
      }
    };

    videoCanvas = hapi.layout.getVideoCanvas();
    canvas = global.document.getElementById("canvas");
    videoCanvas.setPosition(canvas.offsetLeft, canvas.offsetTop);
    videoCanvas.setWidth(canvas.offsetWidth);
    videoCanvas.setVisible(true);

    hapi.onEnabledParticipantsChanged.add(chooseTarget);
    chooseTarget();
    solve();
    shuffle(myId);

    hapi.data.onMessageReceived.add(function (event) {
      var message = JSON.parse(event.message);
      if (message.participant == myId) {
        move(-message.dx, message.dy, myId);
      }
    });
  }

  hapi.onApiReady.add(function (event) {
    if (event.isApiReady) {
      start();
    }
  });

}(this));
