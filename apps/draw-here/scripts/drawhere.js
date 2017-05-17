/*
 * Copyright (c) 2013 Gerwin Sturm, FoldedSoft e.U. / www.foldedsoft.at
 *
 * Licensed under the Apache License, Version 2.0 (the "License"); you may
 * not use this file except in compliance with the License. You may obtain
 * a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
 * WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
 * License for the specific language governing permissions and limitations under
 * the License.
 */

(function (global) {
  "use strict";
  var hapi, window = global.window, document = global.document, console = global.console, drawhere;
  if (global.gapi && global.gapi.hangout) {
    hapi = global.gapi.hangout;
  }

  function Drawhere() {

    var
      PAINT = 0, LINE = 1, RECT = 2, ELLIPSE = 3, ERASE = 4, toolClasses = [],
      mainDiv, editDiv, imageTag,
      video, canvas, drawCanvas, ctx, drawCtx,
      dotResource, dotOverlay, drawOverlay,
      history = [], maxHistory = 50,
      cursorCanvas, cursorCtx, currentColor, currentFillColor, drawing, lastUpdate,
      changed, drawChanged, overlay, size = 1, opacity = 1, fillOpacity = 0,
      imgOverlay, imgBackgroundOverlay, foreColor, fillColor, currentTool = PAINT,
      startX, startY, endX, endY, exampleDiv, sliderDiv, wrapperDiv, toolsDiv, backDiv, startW, endW, ratio = 1.5,
      imgWidth = 1, imgHeight = 1;

    toolClasses[PAINT] = "tool_paint";
    toolClasses[LINE] = "tool_line";
    toolClasses[RECT] = "tool_square";
    toolClasses[ELLIPSE] = "tool_circle";
    toolClasses[ERASE] = "tool_erase";

    function repositionVideo() {
      if (!hapi) { return; }
      var
        width = mainDiv.offsetWidth - editDiv.offsetWidth,
        height = mainDiv.offsetHeight,
        left = editDiv.offsetLeft + editDiv.offsetWidth,
        top = mainDiv.offsetTop,
        aspect = video.getAspectRatio(),
        videoWidth, videoHeight, videoTop, videoLeft;

      videoWidth = width * 0.9;
      videoHeight = videoWidth / aspect;
      if (videoHeight > height * 0.95) {
        videoHeight = height * 0.95;
        videoWidth = videoHeight * aspect;
      }
      videoTop = 5;
      videoLeft = left + (width - videoWidth) / 2;

      video.setPosition(videoLeft, videoTop);
      video.setWidth(videoWidth);
    }

    function updateOverlay(force) {
      var now, oldOverlay, oldDot, imgData, img;
      if (!hapi) { return; }
      now = (new Date()).getTime();
      if (now - lastUpdate > 120 || force) {
        lastUpdate = now;
        if (changed || force) {
          imgData = canvas.toDataURL("image/png");

          changed = false;
          if (overlay) {
            oldOverlay = overlay;
          }
          overlay = hapi.av.effects.createImageResource(imgData).showOverlay({scale: {magnitude: 1.001, reference: hapi.av.effects.ScaleReference.WIDTH}});
          if (oldOverlay) {
            oldOverlay.setVisible(false);
            oldOverlay.getImageResource().dispose();
            oldOverlay = null;
          }
        }
        if (drawOverlay) {
          oldOverlay = drawOverlay;
        }
        if (drawChanged || !drawOverlay || !oldOverlay) {
          drawChanged = false;
          imgData = drawCanvas.toDataURL("image/png");
          drawOverlay = hapi.av.effects.createImageResource(imgData).showOverlay({scale: {magnitude: 1.001, reference: hapi.av.effects.ScaleReference.WIDTH}});
          if (oldOverlay) {
            oldOverlay.setVisible(false);
            oldOverlay.getImageResource().dispose();
            oldOverlay = null;
          }
        } else {
          drawOverlay = oldOverlay.getImageResource().showOverlay({scale: {magnitude: 1.01, reference: hapi.av.effects.ScaleReference.WIDTH}});
          oldOverlay.setVisible(false);
          oldOverlay.dispose();
          oldOverlay = null;
        }
        oldDot = dotOverlay;
        dotOverlay = dotResource.createOverlay({scale: oldDot.getScale(), position: oldDot.getPosition()});
        if (oldDot.isVisible()) {
          dotOverlay.setVisible(true);
        }
        oldDot.dispose();
      }
    }

    function updateDrawCanvas() {
      var x, y, w, h;
      drawCtx.clearRect(0, 0, drawCanvas.width, drawCanvas.height);
      if (drawing && currentTool === LINE) {
        drawCtx.beginPath();
        drawCtx.moveTo(startX, startY);
        drawCtx.lineTo(endX, endY);
        drawCtx.stroke();
        drawCtx.closePath();
      }
      if (drawing && currentTool === RECT) {
        drawCtx.beginPath();
        drawCtx.rect(startX, startY, endX - startX, endY - startY);
        drawCtx.fill();
        drawCtx.stroke();
        drawCtx.closePath();
      }
      if (drawing && currentTool === ELLIPSE) {
        x = startX;
        y = startY;
        w = Math.abs(endX - startX);
        h = Math.abs(endY - startY);
        if (h === 0) { h = 1; }
        if (w === 0) { w = 1; }
        drawCtx.save();
        drawCtx.beginPath();
        drawCtx.strokeStyle = "black";
        drawCtx.lineWidth = 2;
        drawCtx.rect(x - w, y - h, 2 * w, 2 * h);
        drawCtx.stroke();
        drawCtx.closePath();
        drawCtx.restore();

        drawCtx.save();
        drawCtx.translate(x, y);
        drawCtx.scale(w, h);
        drawCtx.beginPath();
        drawCtx.arc(0, 0, 1, 0, Math.PI * 2, false);
        drawCtx.restore();
        drawCtx.fill();
        drawCtx.stroke();
        drawCtx.closePath();
      }
      drawChanged = true;
    }

    function finishStroke() {
      var x, y, w, h;
      drawing = false;
      if (currentTool === LINE) {
        ctx.moveTo(startX, startY);
        ctx.lineTo(endX, endY);
        ctx.stroke();
      }
      if (currentTool === RECT) {
        ctx.rect(startX, startY, endX - startX, endY - startY);
        ctx.fill();
        ctx.stroke();
      }
      if (currentTool === ELLIPSE) {
        x = startX;
        y = startY;
        w = Math.abs(endX - startX);
        h = Math.abs(endY - startY);
        if (h === 0) { h = 1; }
        if (w === 0) { w = 1; }
        ctx.save();
        ctx.translate(x, y);
        ctx.scale(w, h);
        ctx.beginPath();
        ctx.arc(0, 0, 1, 0, Math.PI * 2, false);
        ctx.restore();
        ctx.fill();
        ctx.stroke();
      }
      ctx.closePath();
      updateDrawCanvas();
      updateOverlay(true);
    }

    function historyPush() {
      history.push({
        width: canvas.width,
        height: canvas.height,
        imgdata: canvas.toDataURL("image/png")
      });
    }

    function clear() {
      historyPush();
      ctx.clearRect(0, 0, canvas.width, canvas.height);
      updateOverlay(true);
    }

    function hideImage() {
      if (imgOverlay && !imgOverlay.isDisposed()) {
        imgOverlay.setVisible(false);
        imgBackgroundOverlay.setVisible(false);
      }
      imageTag.style.display = "none";
      document.getElementById("drshowimg").style.display = "inline-block";
      document.getElementById("drhideimg").style.display = "none";
    }

    function showImage() {
      if (imgOverlay && !imgOverlay.isDisposed()) {
        imgBackgroundOverlay.setVisible(true);
        imgOverlay.setVisible(true);
        updateOverlay(true);
      }
      document.getElementById("drhideimg").style.display = "inline-block";
      document.getElementById("drshowimg").style.display = "none";
      imageTag.style.display = "inline-block";
    }

    function undo() {
      var oldImg, img;
      if (history.length > 0) {
        oldImg = history.pop();
        img = new global.Image();
        img.onload = function () {
          ctx.clearRect(0, 0, canvas.width, canvas.height);
          ctx.drawImage(img, 0, 0, oldImg.width, oldImg.height, 0, 0, canvas.width, canvas.height);
          updateOverlay(true);
        };
        img.src = oldImg.imgdata;
      } else {
        ctx.clearRect(0, 0, canvas.width, canvas.height);
        updateOverlay(true);
      }
    }

    function handleMouseMove(e) {
      var x, y;
      x = e.offsetX || e.layerX || 0;
      y = e.offsetY || e.layerY || 0;

      if (drawing) {
        if (currentTool === ERASE || currentTool === PAINT) {
          ctx.lineTo(x, y);
          ctx.stroke();
        }
        if (currentTool === LINE || currentTool === RECT || currentTool === ELLIPSE) {
          endX = x;
          endY = y;
          updateDrawCanvas();
        }
        changed = true;
        updateOverlay(false);
      }

      x = x / canvas.offsetWidth - 0.5;
      y = y / canvas.offsetHeight - 0.5;
      if (dotOverlay) {
        dotOverlay.setPosition(x, y);
        dotOverlay.setVisible(true);
      }
    }

    function handleMouseOver(e) {
      if (dotOverlay) { dotOverlay.setVisible(true); }
    }

    function handleMouseOut(e) {
      if (dotOverlay) { dotOverlay.setVisible(false); }
      if (drawing) {
        finishStroke();
      }
    }

    function handleMouseDown(e) {
      var x, y;
      if (e.button === 0) {
        drawing = true;
        if (history.length > maxHistory) {
          history.shift();
        }
        historyPush();

        ctx.lineWidth = canvas.width * 0.035 * size;
        drawCtx.lineWidth = ctx.lineWidth;
        if (currentTool === ERASE) {
          ctx.strokeStyle = "rgba(1,1,1,0)";
          ctx.globalCompositeOperation = "copy";
        } else {
          ctx.strokeStyle = currentColor;
          ctx.fillStyle = currentFillColor;
          drawCtx.strokeStyle = currentColor;
          drawCtx.fillStyle = currentFillColor;
          ctx.globalCompositeOperation = "source-over";
        }

        ctx.beginPath();
        x = e.offsetX || e.layerX || 0;
        y = e.offsetY || e.layerY || 0;
        ctx.moveTo(x, y);
        startX = x;
        startY = y;
      }
    }

    function handleMouseUp(e) {
      if (e.button === 0 && drawing) {
        finishStroke();
      }
    }

    function updateExample() {
      exampleDiv.style.border = Math.max(Math.round(size * 12, 0), 1) + "px solid " + currentColor;
      exampleDiv.style.backgroundColor = currentFillColor;
    }

    function drawCursor(color) {
      cursorCtx.clearRect(0, 0, 60, 60);
      cursorCtx.beginPath();
      cursorCtx.arc(30, 30, 25, 0, 2 * Math.PI, false);
      if (currentTool === ERASE) {
        cursorCtx.fillStyle = "rgba(1,1,1,0.2)";
        cursorCtx.fill();
      } else {
        cursorCtx.fillStyle = color;
        cursorCtx.fill();
      }
      cursorCtx.lineWidth = 2;
      cursorCtx.strokeStyle = "black";
      cursorCtx.stroke();
      cursorCtx.closePath();


      cursorCtx.fillStyle = "rgba(0,0,0,0)";
      if (currentTool === ERASE) {
        cursorCtx.beginPath();
        cursorCtx.moveTo(0, 0);
        cursorCtx.lineTo(60, 60);
        cursorCtx.stroke();
        cursorCtx.closePath();

        cursorCtx.beginPath();
        cursorCtx.moveTo(0, 60);
        cursorCtx.lineTo(60, 0);
        cursorCtx.stroke();
        cursorCtx.closePath();
      }

      if (currentTool === LINE) {
        cursorCtx.beginPath();
        cursorCtx.moveTo(20, 40);
        cursorCtx.lineTo(40, 20);
        cursorCtx.stroke();
        cursorCtx.closePath();
      }

      if (currentTool === RECT) {
        cursorCtx.beginPath();
        cursorCtx.rect(20, 20, 21, 21);
        cursorCtx.stroke();
        cursorCtx.closePath();
      }

      if (currentTool === ELLIPSE) {
        cursorCtx.beginPath();
        cursorCtx.arc(30, 30, 15, 0, 2 * Math.PI, false);
        cursorCtx.stroke();
        cursorCtx.closePath();
      }

      if (dotOverlay) {
        dotOverlay.setVisible(false);
        dotResource.dispose();
      }

      ctx.lineWidth = canvas.width * 0.035 * size;
      ctx.strokeStyle = color;
      drawCtx.lineWidth = ctx.lineWidth;
      drawCtx.strokeStyle = color;

      if (hapi) {
        dotResource = hapi.av.effects.createImageResource(cursorCanvas.toDataURL("image/png"));
        dotOverlay = dotResource.createOverlay({scale: {magnitude: 0.05 * size, reference: hapi.av.effects.ScaleReference.WIDTH}});
      }

      updateExample(color);
    }

    function handleColorChange() {
      currentColor = "rgba(" + Math.floor(foreColor.color.rgb[0] * 255) + "," + Math.floor(foreColor.color.rgb[1] * 255) + "," + Math.floor(foreColor.color.rgb[2] * 255) + "," + opacity + ")";
      drawCursor(currentColor);
    }

    function handleFillColorChange() {
      currentFillColor = "rgba(" + Math.floor(fillColor.color.rgb[0] * 255) + "," + Math.floor(fillColor.color.rgb[1] * 255) + "," + Math.floor(fillColor.color.rgb[2] * 255) + "," + fillOpacity + ")";
      updateExample();
    }

    function changeSize(e) {
      size = e.target.value / 50;
      ctx.lineWidth = canvas.width * 0.035 * size;
      drawCtx.lineWidth = ctx.lineWidth;
      if (dotOverlay) {
        dotOverlay.dispose();
        dotOverlay = dotResource.createOverlay({scale: {magnitude: 0.05 * size, reference: hapi.av.effects.ScaleReference.WIDTH}});
      }
      updateExample();
    }

    function changeOpacity(e) {
      opacity = e.target.value / 100;
      handleColorChange();
    }

    function changeFillOpacity(e) {
      fillOpacity = e.target.value / 100;
      handleFillColorChange();
    }



    function handleFile(f) {
      var reader;
      reader = new global.FileReader();

      reader.onload = function () {
        var image = new global.Image();

        image.onload = function () {
          var w, h, scale;
          w = image.width;
          h = image.height;
          imgWidth = w;
          imgHeight = h;

          if (imgOverlay && !imgOverlay.isDisposed()) {
            imgOverlay.getImageResource().dispose();
          }

          h = h * (canvas.width - 2) / w;
          w = canvas.width - 2;

          if (h > canvas.height) {
            if (hapi) {
              scale = {scale: {magnitude: 1.01, reference: hapi.av.effects.ScaleReference.HEIGHT}};
            }
            w = w * (canvas.height - 2) / h;
            h = canvas.height - 2;
            imageTag.style.marginTop = "0px";
          } else {
            imageTag.style.marginTop = Math.floor((canvas.height - h) / 2) + "px";
            if (hapi) {
              scale = {scale: {magnitude: 1.01, reference: hapi.av.effects.ScaleReference.WIDTH}};
            }
          }

          imageTag.style.width = Math.floor(w) + "px";
          imageTag.style.height = Math.floor(h) + "px";
          imageTag.src = image.src;

          if (hapi) {
            imgOverlay =
              hapi.av.effects.createImageResource(reader.result)
              .createOverlay(scale);
          }
          showImage();
        };

        image.src = reader.result;
      };

      reader.readAsDataURL(f);
    }

    function handleFileSelect(eventObj) {
      var i, l, files;
      eventObj.stopPropagation();
      eventObj.preventDefault();

      files = eventObj.dataTransfer.files;
      l = files.length;
      for (i = 0; i < l; i++) {
        if (files[i].type.indexOf("image") === 0) {
          handleFile(files[i]);
          break;
        }
      }

      drawCanvas.classList.remove("dragging");
    }

    function handleDragOver(eventObj) {
      eventObj.stopPropagation();
      eventObj.preventDefault();
      eventObj.dataTransfer.dropEffect = "copy";
    }

    function createImageBackground() {
      var tmpCanvas, tmpCtx, tmpImg;
      tmpCanvas = document.createElement("canvas");
      tmpCanvas.width = canvas.width;
      tmpCanvas.height = canvas.height;
      tmpCtx = tmpCanvas.getContext("2d");
      tmpCtx.fillStyle = "black";
      tmpCtx.fillRect(0, 0, tmpCanvas.width, tmpCanvas.height);
      tmpImg = tmpCanvas.toDataURL("image/png");
      if (hapi) {
        imgBackgroundOverlay = hapi.av.effects.createImageResource(tmpImg).createOverlay({scale: {magnitude: 1.1, reference: hapi.av.effects.ScaleReference.WIDTH}});
      }
    }

    function switchTool(nr) {
      var className, tmpTool;
      currentTool = nr;
      className = toolClasses[nr];
      tmpTool = document.querySelector(".tool_selected");
      if (tmpTool) {
        tmpTool.className = tmpTool.className.replace(/(?:^|\s)tool_selected(?!\S)/g, "");
      }
      tmpTool = document.querySelector("." + className);
      if (tmpTool) {
        tmpTool.className += " tool_selected";
      }
      drawCursor(currentColor);
    }

    function resizeImage() {
      var w, h;
      w = imgWidth;
      h = imgHeight;
      h = h * (canvas.width - 2) / w;
      w = canvas.width - 2;
      if (h > canvas.height) {
        w = w * (canvas.height - 2) / h;
        h = canvas.height - 2;
        imageTag.style.marginTop = "0px";
      } else {
        imageTag.style.marginTop = Math.floor((canvas.height - h) / 2) + "px";
      }
      imageTag.style.width = Math.floor(w) + "px";
      imageTag.style.height = Math.floor(h) + "px";
    }

    function doResize(e) {
      var height;
      endW = e.clientX || e.PageX;
      if (endW - startW > 310) {
        sliderDiv.style.left = (endW - startW) + "px";
        editDiv.style.width = (endW - startW - 10) + "px";
        height = Math.floor(canvas.offsetWidth / ratio);
        wrapperDiv.style.height =  height + "px";
        canvas.width = canvas.offsetWidth;
        canvas.height = height;
        drawCanvas.width = canvas.offsetWidth;
        drawCanvas.height = height;
        toolsDiv.style.top = (height + 20) + "px";
        backDiv.style.paddingTop = Math.floor(height / 2 - 15) + "px";
        resizeImage();
        if (hapi) { repositionVideo(); }
      }
    }

    function stopResize(e) {
      document.removeEventListener("mousemove", doResize, false);
      document.removeEventListener("mouseup", stopResize, false);
      undo();
    }

    function startResize(e) {
      historyPush();
      document.addEventListener("mousemove", doResize, false);
      document.addEventListener("mouseup", stopResize, false);
      startW = (e.clientX || e.PageX) - sliderDiv.offsetLeft;
    }

    function initialize() {
      var height, i, l, tmpDiv;

      lastUpdate = (new Date()).getTime();
      mainDiv = document.getElementById("drawhere");
      editDiv = document.getElementById("dredit");
      imageTag = document.getElementById("drimage");
      canvas = document.getElementById("drcanvas");
      drawCanvas = document.getElementById("drawcanvas");
      cursorCanvas = document.getElementById("drcursor");
      sliderDiv = document.getElementById("drslider");
      wrapperDiv = document.getElementById("drwrapper");
      toolsDiv = document.getElementById("drtools");
      backDiv = document.getElementById("drcanvasback");
      sliderDiv.onmousedown = startResize;

      cursorCtx = cursorCanvas.getContext("2d");

      if (hapi) {
        hapi.av.setLocalParticipantVideoMirrored(false);
        video = hapi.layout.getVideoCanvas();

        video.setVideoFeed(hapi.layout.createParticipantVideoFeed(hapi.getLocalParticipantId()));

        repositionVideo();
        ratio = video.getAspectRatio();
      }
      height = Math.floor(canvas.offsetWidth / ratio);
      wrapperDiv.style.height = height + "px";
      canvas.height = height;
      canvas.width = canvas.offsetWidth;
      drawCanvas.height = height;
      drawCanvas.width = drawCanvas.offsetWidth;

      ctx = canvas.getContext("2d");
      drawCtx = drawCanvas.getContext("2d");

      createImageBackground();

      toolsDiv.style.top = (height + 20) + "px";

      exampleDiv = document.getElementById("example");
      foreColor = document.getElementById("color");
      foreColor.onchange = handleColorChange;

      fillColor = document.getElementById("fillcolor");
      fillColor.onchange = handleFillColorChange;

      currentColor = "#00FF00";
      currentFillColor = "rgba(255,255,255,0)";
      drawCursor(currentColor);

      if (video) { video.setVisible(true); }

      window.onresize = repositionVideo;
      drawCanvas.onmousemove = handleMouseMove;
      drawCanvas.onmouseout = handleMouseOut;
      drawCanvas.onmouseover = handleMouseOver;
      drawCanvas.onmousedown = handleMouseDown;
      drawCanvas.onmouseup = handleMouseUp;

      drawCanvas.addEventListener("dragover", handleDragOver, false);
      drawCanvas.addEventListener("drop", handleFileSelect, false);
      drawCanvas.addEventListener("dragenter", function () {
        drawCanvas.classList.add("dragging");
      }, false);
      drawCanvas.addEventListener("dragleave", function () {
        drawCanvas.classList.remove("dragging");
      }, false);

      if (hapi) {
        hapi.onAppVisible.add(function (e) {
          if (e.isAppVisible) {
            hapi.av.setLocalParticipantVideoMirrored(false);
          } else {
            hapi.av.setLocalParticipantVideoMirrored(true);
            dotOverlay.setVisible(false);
          }
        });
      }

      document.getElementById("drsize").onchange = changeSize;
      document.getElementById("dropacity").onchange = changeOpacity;
      document.getElementById("fillopacity").onchange = changeFillOpacity;

      document.querySelector(".tool_undo").onclick = undo;
      document.querySelector(".tool_clear").onclick = clear;
      document.querySelector(".tool_paint").onclick = function () { switchTool(PAINT); };
      document.querySelector(".tool_erase").onclick = function () { switchTool(ERASE); };
      document.querySelector(".tool_line").onclick = function () { switchTool(LINE); };
      document.querySelector(".tool_square").onclick = function () { switchTool(RECT); };
      document.querySelector(".tool_circle").onclick = function () { switchTool(ELLIPSE); };

      document.getElementById("drshowimg").onclick = showImage;
      document.getElementById("drhideimg").onclick = hideImage;

      document.onkeypress = function (e) {
        var keyCode = e.keyCode || e.which;
        if (keyCode) {
          switch (String.fromCharCode(keyCode)) {
          case "l":
            switchTool(LINE); break;
          case "s":
          case "r":
            switchTool(RECT); break;
          case "c":
            switchTool(ELLIPSE); break;
          case "p":
          case "b":
            switchTool(PAINT); break;
          case "e":
            switchTool(ERASE); break;
          }
        }
      };
    }

    if (hapi) {
      hapi.onApiReady.add(function (e) {
        if (e.isApiReady) {
          window.setTimeout(initialize, 1);
        }
      });
    } else {
      initialize();
    }
  }

  drawhere = new Drawhere();

}(this));