(function (global) {

  var hapi = global.gapi.hangout;

  function start() {
    var
      metaEffect = hapi.av.effects.createMetaEffect(),
      effectChain = [],
      r,
      duotones = [
        {
          color1: {r: 0, g: 0, b: 255},
          color2: {r: 255, g: 255, b: 0}
        },
        {
          color1: {r: 0, g: 150, b: 0},
          color2: {r: 255, g: 255, b: 0}
        },
        {
          color1: {r: 255, g: 0, b: 0},
          color2: {r: 255, g: 255, b: 0}
        },
        {
          color1: {r: 200, g: 0, b: 200},
          color2: {r: 255, g: 255, b: 0}
        }
      ], overlays = [
        {
          resource: {key: 'r0'},
          scale: 0.5,
          h_align: -1,
          v_align: 0
        },
        {
          resource: {key: 'r1'},
          scale: 0.5,
          h_align: 0,
          v_align: 0
        },
        {
          resource: {key: 'r2'},
          scale: 0.5,
          h_align: 0,
          v_align: -1
        },
        {
          resource: {key: 'r3'},
          scale: 0.5,
          h_align: -1,
          v_align: -1
        }
      ];

    for (r = 0; r < 4; r++) {
      effectChain.push(
        metaEffect.createSubEffect('copy', {resource_key: 'r' + r})
      );

      effectChain.push(
        metaEffect.createSubEffect('duotone', duotones[r])
      );

      effectChain.push(
        metaEffect.createSubEffect('swap', {resource_key: 'r' + r})
      );
    }

    for (r = 0; r < 4; r++) {
      effectChain.push(
        metaEffect.createSubEffect('static_overlay', overlays[r])
      );
    }

    metaEffect.initEffects(effectChain);
    metaEffect.pipelineEffects(effectChain);
  }

  hapi.onApiReady.add(function (event) {
    if (event.isApiReady) {
      start();
    }
  });

}(this));