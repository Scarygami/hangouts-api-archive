part of hangouts_api;

/// Provides ability to add sound effects and attach image overlays to faces.
class HangoutAvEffects {

  FaceTrackingFeatureEnum _faceTrackingFeature;

  /**
   * Identifiers for the features that can be tracked by a [FaceTrackingOverlay].
   * "Left" and "right" are from how others view the face.
   */
  FaceTrackingFeatureEnum get FaceTrackingFeature => _faceTrackingFeature;

  ResourceStateEnum _resourceState;

  /// Possible states of a resource.
  ResourceStateEnum get ResourceState => _resourceState;

  ScaleReferenceEnum _scaleReference;

  /// Possible values for the aspect of the video feed that an [Overlay] is scaled relative to.
  ScaleReferenceEnum get ScaleReference => _scaleReference;

  FaceTrackingDataChangedHandler _onFaceTrackingDataChanged;

  /// Handles callbacks to be called when the local participant starts or stops sending video.
  FaceTrackingDataChangedHandler get onFaceTrackingDataChanged => _onFaceTrackingDataChanged;

  HangoutAvEffects._internal() {
    _onFaceTrackingDataChanged = new FaceTrackingDataChangedHandler._internal();

    var data = context["gapi"]["hangout"]["av"]["effects"]["FaceTrackingFeature"];
    _faceTrackingFeature = new FaceTrackingFeatureEnum._internal(data);

    data = context["gapi"]["hangout"]["av"]["effects"]["ResourceState"];
    _resourceState = new ResourceStateEnum._internal(data);

    data = context["gapi"]["hangout"]["av"]["effects"]["ScaleReference"];
    _scaleReference = new ScaleReferenceEnum._internal(data);
  }

  /**
   * Creates a new [AudioResource].
   * Warning: Creating an audio resource allocates memory in the plugin.
   * Allocating too many resources without disposing them can cause the hangout to run out of memory and halt.
   * Dispose of audio resources by using the dispose method.
   */
  AudioResource createAudioResource(String url) {
    var data = _makeProxyCall(["av", "effects", "createAudioResource"], [url]);
    return new AudioResource._internal(data);
  }

  /// Creates a new [BackgroundBlur].
  BackgroundBlur createBackgroundBlur() {
    var data = _makeProxyCall(["av", "effects", "createBackgroundBlur"]);
    return new BackgroundBlur._internal(data);
  }

  /**
   * Creates a new [ImageResource].
   * Warning: Creating an image resource allocates memory in the plugin.
   * Allocating too many resources without disposing them can cause the hangout to run out of memory and halt.
   * Dispose of image resources by using the dispose method.
   */
  ImageResource createImageResource(String url, [List<Map<String, num>> opt_interestRegions]) {
    var data;
    if (opt_interestRegions == null) {
      data = _makeProxyCall(["av", "effects", "createImageResource"], [url]);
    } else {
      data = _makeProxyCall(["av", "effects", "createImageResource"], [url, opt_interestRegions]);
    }
    return new ImageResource._internal(data);
  }

  /**
   * Gets an instance of a background replacement if the background replacement lock has been acquired.
   * Otherwise, returns null.
   */
  BackgroundReplacement getBackgroundReplacement() {
    var data = _makeProxyCall(["av", "effects", "createBackgroundBlur"]);
    if (data == null) { return null; }
    return new BackgroundReplacement._internal(data);
  }

  /// Returns true if the lock for background replacement has been acquired, false otherwise.
  bool hasBackgroundReplacementLock() => _makeBoolCall(["av", "effects", "hasBackgroundReplacementLock"]);

  /**
   * Requests the lock for background replacement.
   * callback: The callback function to receive the result of the lock request.
   */
  void requestBackgroundReplacementLock(void callback(bool success)) {
    context["gapi"]["hangout"]["av"]["effects"]["requestBackgroundReplacementLock"].apply([([JsObject eventData]) {
      if (eventData != null && eventData is bool && eventData == true) {
        callback(true);
      } else {
        callback(false);
      }
    }]);
  }

  /// Releases the lock for background replacement.
  void releaseBackgroundReplacementLock() => _makeVoidCall(["av", "effects", "releaseBackgroundReplacementLock"]);
}

/**
 *  Object used to load an audio file which can be used to play sounds.
 *  Create an AudioResource with createAudioResource.
 */
class AudioResource extends ProxyObject {

  ResourceLoadHandler _onLoad;

  /// Handles callback to be called when resource loads.
  ResourceLoadHandler get onLoad => _onLoad;

  AudioResource._internal(JsObject proxy) : super._internal(proxy) {
    _onLoad = new ResourceLoadHandler._internal(_proxy);
  }

  /**
   *  Creates a new instance of a sound.
   *
   *  opt_params : {localOnly: boolean, loop: boolean, volume: number}
   *  The options for the newly created sound.
   *  If the localOnly parameter is true, the sound plays only to the local participant;
   *  if false, the sound plays to all participants and, if in a Hangout On Air, to broadcast viewers.
   */
  Sound createSound([Map optParams]) {
    var data;
    if (optParams != null)
      data = _proxy.callMethod("createSound", [_createParamProxy(optParams)]);
    else
      data = _proxy.callMethod("createSound");

    return new Sound._internal(this, data);
  }

  /// Disposes the resource and all sounds created from the resource.
  void dispose() => _proxy.callMethod("dispose");

  /// Returns the state of the resource.
  String getState() => _proxy.callMethod("getState");

  /// Returns the URL of the audio file for the resource.
  String getUrl() => _proxy.callMethod("getUrl");

  /// Returns true if the resource has been disposed.
  bool isDisposed() => _proxy.callMethod("isDisposed");

  /// Returns true if the resource has successfully loaded.
  bool isLoaded() => _proxy.callMethod("isLoaded");

  /**
   *  Creates a new instance of a sound and starts it playing.
   *
   *  opt_params : {localOnly: boolean, loop: boolean, volume: number}
   *  The options for the newly created sound.
   *  If the localOnly parameter is true, the sound plays only to the local participant;
   *  if false, the sound plays to all participants and, if in a Hangout On Air, to broadcast viewers.
   */
  Sound play([Map optParams]) {
    var data;
    if (optParams != null)
      data = _proxy.callMethod("play", [_createParamProxy(optParams)]);
    else
      data = _proxy.callMethod("play");

    return new Sound._internal(this, data);
  }

}

/**
 * Object used to blur the background in the video feed of the local participant.
 * Create a BackgroundBlur instance with createBackgroundBlur.
 */
class BackgroundBlur extends ProxyObject {

  BackgroundBlur._internal(JsObject proxy) : super._internal(proxy);

  /// Disposes the overlay.
  void dispose() => _proxy.callMethod("dispose");

  /// Returns the alpha map threshold for background recognition.
  num getAlphaThreshold() => _proxy.callMethod("getAlphaThreshold");

  /// Returns the blur window size for background blur.
  num getBlurWindowSize() => _proxy.callMethod("getBlurWindowSize");

  /// Returns true if the alpha map threshold for background blur is being automatically updated.
  bool isAlphaThresholdAutoUpdating() => _proxy.callMethod("isAlphaThresholdAutoUpdating");

  /// Returns true if the background blur has been disposed.
  bool isDisposed() => _proxy.callMethod("isDisposed");

  /// Returns true if the background is being blurred in the local participant's video feed, false otherwise.
  bool isVisible() => _proxy.callMethod("isVisible");

  /// Sets the alpha map threshold for background recognition.
  void setAlphaThreshold(num alphaThreshold) => _proxy.callMethod("setAlphaThreshold", [alphaThreshold]);

  /// Sets whether the alpha map threshold for background recognition should be automatically updated for every single frame.
  void setAlphaThresholdAutoUpdating(bool autoUpdating) => _proxy.callMethod("setAlphaThresholdAutoUpdating", [autoUpdating]);

  /**
   * Sets the blur window size for background blur.
   * Blur window size is used to control the amount of blur:
   * for each pixel (x, y), it is blurred by taking the average color of pixels within the window
   * (x - blurWindowSize / 2, y - blurWindowSize / 2) to (x + blurWindowSize / 2, y + blurWindowSize / 2).
   */
  void setBlurWindowSize(num blurWindowSize) => _proxy.callMethod("setBlurWindowSize", [blurWindowSize]);

  /// Sets the image overlay to be visible or not.
  void setVisible(bool visible) => _proxy.callMethod("setVisible", [visible]);
}

/**
 * Object used to replace the background with other images in the video feed of the local participant.
 * The replacement background image is visible to all participants.
 * Get a BackgroundReplacement instance using getBackgroundReplacement
 */
class BackgroundReplacement extends ProxyObject {

  ImageResource _imageResource;

  BackgroundReplacement._internal(JsObject proxy) : super._internal(proxy);

  /**
   * Returns the alpha map threshold for the background replacement.
   * For background replacement, each pixel is rated on how likely it is to be part of the background,
   * from 0 to 255, where 0 means certainly part of the foreground (opaque video)
   * and 255 means certainly part of the background (transparent video).
   * The alpha threshold indicates where you want to set the threshold for replacement.
   * By setting the threshold low, you will aggressively replace low-confidence pixels, and by setting it close to 255,
   * you will be conservative about which pixels to replace.
   */
  num getAlphaThreshold() => _proxy.callMethod("getAlphaThreshold");

  /// Returns the [ImageResource] used to create this object.
  ImageResource getImageResource() => _imageResource;

  /// Returns true if the alpha map threshold is being automatically updated.
  bool isAlphaThresholdAutoUpdating() => _proxy.callMethod("isAlphaThresholdAutoUpdating");

  /// Returns true if the background replacement has been disposed.
  bool isDisposed() => _proxy.callMethod("isDisposed");

  /// Returns true if the background model is being updated, false otherwise.
  bool isModelUpdating() => _proxy.callMethod("isModelUpdating");

  /// Returns true if the background is being replaced with given image in the local participant's video feed, false otherwise.
  bool isVisible() => _proxy.callMethod("isVisible");

  /// Resets the internal background model for the background replacement
  void resetModel() => _proxy.callMethod("resetModel");

  /// Sets the alpha map threshold for the background replacement.
  void setAlphaThreshold(num alphaThreshold) => _proxy.callMethod("setAlphaThreshold", [alphaThreshold]);

  /// Sets whether alpha map threshold should be automatically updated for every single frame.
  void setAlphaThresholdAutoUpdating(bool autoUpdating) => _proxy.callMethod("setAlphaThresholdAutoUpdating", [autoUpdating]);

  /// Sets which video feed is being shown on this canvas.
  void setImageResource(ImageResource resource) {
    _imageResource = resource;
    _proxy.callMethod("setImageResource", [resource._proxy]);
  }

  /// Sets the replaced background to be visible or not.
  void setModelUpdating(bool updateModel) => _proxy.callMethod("setModelUpdating", [updateModel]);

  /// Sets the replaced background to be visible or not.
  void setVisible(bool visible) => _proxy.callMethod("setVisible", [visible]);
}

/**
 * Object used to control one instance of an image that tracks a face and is laid over the video feed of the local participant.
 * The image is visible to all participants.
 * Create a FaceTrackingOverlay using createFaceTrackingOverlay or showFaceTrackingOverlay.
 */
class FaceTrackingOverlay extends ProxyObject {

  ImageResource _imageResource;

  FaceTrackingOverlay._internal(ImageResource this._imageResource, JsObject proxy) : super._internal(proxy);

  /// Disposes the overlay.
  void dispose() => _proxy.callMethod("dispose");

  /// Returns the [ImageResource] used to create this object.
  ImageResource getImageResource() => _imageResource;

  /// Returns the offset of the image overlay from the [FaceTrackingFeatureEnum].
  Map<String, num> getOffset() {
    var data, pos;
    data = _proxy.callMethod("getOffset");
    if (data != null) pos = JSON.decode(context["JSON"]["stringify"].apply([data]));
    return pos;
  }

  /// Returns true if the image will rotate as the face rotates, false otherwise.
  bool getRotateWithFace() => _proxy.callMethod("getRotateWithFace");

  /**
   * Returns the base rotation of an image in radians.
   * This does not include any rotation occurring because of the getRotateWithFace flag.
   */
  num getRotation() => _proxy.callMethod("getRotation");

  /**
   * Returns the scale in relation to the natural image size of the overlay.
   * This does not include any scaling occurring because of the getScaleWithFace flag.
   * Example: a scale of 2 would cause the image to be twice its natural size.
   */
  num getScale() => _proxy.callMethod("getScale");

  /// Returns true if the size of the image will scale with the size of the face that is being tracked, false otherwise.
  bool getScaleWithFace() => _proxy.callMethod("getScaleWithFace");

  /// Returns the feature of the face that the image overlay is attached to.
  String getTrackingFeature() => _proxy.callMethod("getTrackingFeature");

  /// Returns true if the overlay has been disposed.
  bool isDisposed() => _proxy.callMethod("isDisposed");

  /// Returns true if the image overlay is currently visible in the local participant's video feed, false otherwise.
  bool isVisible() => _proxy.callMethod("isVisible");

  /**
   * Sets the offset of the image overlay from the feature of the face being tracked.
   * With an offset of (0,0), the overlay is centered on the feature.
   *
   * The x offset ranges from -1 to 1, where 1 is the width of the video feed, and positive values move the overlay toward the right.
   * The y offset also ranges from -1 to 1, where 1 is the height of the video feed, and postive values move the overlay toward the bottom.
   *
   * value : number|{x: number, y: number}
   * Either a single number representing the x offset, or a Map with the x, y offset.
   *
   * opt_y : number
   * The y offset (this parameter is ignored if value is an object.)
   */
  void setOffset(value, [num opt_y]) {
    if (value is! num && value is! Map<String, num>) {
      throw(new ArgumentError("value has be be num or Map<String, num>"));
      return;
    }
    if (value is num) {
      if(opt_y != null) {
        _proxy.callMethod("setOffset", [value, opt_y]);
      } else {
        throw(new ArgumentError("If value is num, opt_y has to be set as well"));
      }
    } else {
      _proxy.callMethod("setOffset", [_createParamProxy(value)]);
    }
  }

  /// Sets whether the image should rotate as the face rotates.
  void setRotateWithFace(bool shouldRotate) => _proxy.callMethod("setRotateWithFace", [shouldRotate]);

  /// Sets the rotation for an image in radians. This will be in addition to any rotation caused by setRotateWithFace.
  void setRotation(num rotation) => _proxy.callMethod("setRotation", [rotation]);

  /// Sets the amount an image should be scaled.
  void setScale(num scale) => _proxy.callMethod("setScale", [scale]);

  /// Sets whether an image should scale as the face being tracked gets larger or smaller.
  void setScaleWithFace(bool shouldScale) => _proxy.callMethod("setScaleWithFace", [shouldScale]);

  /// Sets the face feature that the image overlay is attached to.
  void setTrackingFeature(String feature) => _proxy.callMethod("setTrackingFeature", [feature]);

  /// Sets the image overlay to be visible or not.
  void setVisible(bool visible) => _proxy.callMethod("setVisible", [visible]);
}

/**
 * Object used to load an image file which can be overlaid on the video feed.
 * Create an ImageResource with createImageResource.
 */
class ImageResource extends ProxyObject {
  ResourceLoadHandler _onLoad;

  /// Handles callback to be called when resource loads.
  ResourceLoadHandler get onLoad => _onLoad;

  ImageResource._internal(JsObject proxy) : super._internal(proxy) {
    _onLoad = new ResourceLoadHandler._internal(_proxy);
  }

  /**
   * Creates a new instance of a face tracking overlay with this image.
   *
   * opt_params :
   * {trackingFeature: gapi.hangout.av.effects.FaceTrackingFeature,
   *  offset: {x: number, y: number},
   *  rotateWithFace: boolean, rotation: number, scale: number, scaleWithFace: boolean}
   */
  FaceTrackingOverlay createFaceTrackingOverlay([Map optParams]) {
    var data;
    if (optParams != null)
      data = _proxy.callMethod("createFaceTrackingOverlay", [_createParamProxy(optParams)]);
    else
      data = _proxy.callMethod("createFaceTrackingOverlay");

    return new FaceTrackingOverlay._internal(this, data);
  }

  /**
   * Creates a new instance of an overlay with this image.
   *
   * opt_params :
   * {position: {x: number, y: number}, rotation: number,
   * scale: {magnitude: number, reference: gapi.hangout.av.effects.ScaleReference}}
   */
  Overlay createOverlay([Map optParams]) {
    var data;
    if (optParams != null)
      data = _proxy.callMethod("createOverlay", [_createParamProxy(optParams)]);
    else
      data = _proxy.callMethod("createOverlay");

    return new Overlay._internal(this, data);
  }

  /// Disposes the overlay.
  void dispose() => _proxy.callMethod("dispose");

  /// Returns the state of the resource.
  String getState() => _proxy.callMethod("getState");

  /// The URL of the image file for the resource.
  String getUrl() => _proxy.callMethod("getUrl");

  /// Returns true if the resource has been disposed.
  bool isDisposed() => _proxy.callMethod("isDisposed");

  /// Returns true if the resource has successfully loaded.
  bool isLoaded() => _proxy.callMethod("isLoaded");

  /**
   * Creates a new instance of a face tracking overlay with this image and displays it.
   *
   * opt_params :
   * {trackingFeature: gapi.hangout.av.effects.FaceTrackingFeature,
   *  offset: {x: number, y: number},
   *  rotateWithFace: boolean, rotation: number, scale: number, scaleWithFace: boolean}
   */
  FaceTrackingOverlay showFaceTrackingOverlay([Map optParams]) {
    var data;
    if (optParams != null)
      data = _proxy.callMethod("showFaceTrackingOverlay", [_createParamProxy(optParams)]);
    else
      data = _proxy.callMethod("showFaceTrackingOverlay");

    return new FaceTrackingOverlay._internal(this, data);
  }

  /**
   * Creates a new instance of an overlay with this image and displays it.
   *
   * opt_params :
   * {position: {x: number, y: number}, rotation: number,
   * scale: {magnitude: number, reference: gapi.hangout.av.effects.ScaleReference}}
   */
  Overlay showOverlay([Map optParams]) {
    var data;
    if (optParams != null)
      data = _proxy.callMethod("showOverlay", [_createParamProxy(optParams)]);
    else
      data = _proxy.callMethod("showOverlay");

      return new Overlay._internal(this, data);
  }
}

/**
 * Object used to control one instance of an image laid over the video feed of the local participant
 * and is positioned relative to the center of the video feed.
 * The image is visible to all participants.
 * Useful for decorations such as captions, borders, or animations that don't require face tracking.
 * Create an Overlay using createOverlay or showOverlay.
 */
class Overlay extends ProxyObject {

  ImageResource _imageResource;

  Overlay._internal(ImageResource this._imageResource, JsObject proxy) : super._internal(proxy);

  /// Disposes the overlay.
  void dispose() => _proxy.callMethod("dispose");

  /// Returns the [ImageResource] used to create this object.
  ImageResource getImageResource() => _imageResource;

  /// Returns the position of the image overlay
  Map<String, num> getPosition() {
    var data, pos;

    data = _proxy.callMethod("getPosition");
    if (data != null) pos = JSON.decode(context["JSON"].callMethod("stringify", [data]));

    return pos;
  }

  /// Returns the rotation of an image in radians.
  num getRotation() => _proxy.callMethod("getRotation");

  /**
   * Returns the scale of the overlay.
   *
   * Example: a scale of {magnitude: 1, reference: gapi.hangout.av.effects.ScaleReference.WIDTH}
   * would indicate that the image will be scaled so its width is the same as the video feed.
   */
  Map getScale() {
    var data, scale;

    data = _proxy.callMethod("getScale");
    if (data != null) scale = JSON.decode(context["JSON"].callMethod("stringify", [data]));

    return scale;
  }

  /// Returns true if the overlay has been disposed.
  bool isDisposed() => _proxy.callMethod("isDisposed");

  /// Returns true if the image overlay is currently visible in the local participant's video feed, false otherwise.
  bool isVisible() => _proxy.callMethod("isVisible");

  /**
   * Sets the position of the image overlay. With an offset of (0,0), the overlay is centered on the video feed.
   *
   * Positive x values move the overlay toward the right and a value of 1 is equal to the width of the video feed.
   * Positive y values move the overlay toward the bottom and a value of 1 is equal to the height of the video feed.
   *
   * Example: an x of -0.5 and a y of 0.5 would position the overlay in the bottom left corner of the video feed.
   *
   * value : number|{x: number, y: number}
   * Either a single number representing the x position, or an object with the x, y position.
   *
   * opt_y : number
   * The y position (this parameter is ignored if value is an object.)
   */
  void setPosition(value, [num opt_y]) {
    if (value is! num && value is! Map<String, num>) {
      throw(new ArgumentError("value has be be num or Map<String, num>"));
      return;
    }
    if (value is num) {
      if(opt_y != null) {
        _proxy.callMethod("setPosition", [value, opt_y]);
      } else {
        throw(new ArgumentError("If value is num, opt_y has to be set as well"));
      }
    } else {
      _proxy.callMethod("setPosition", [_createParamProxy(value)]);
    }
  }

  /// Sets the rotation for an image in radians.
  void setRotation(num rotation) => _proxy.callMethod("setRotation", [rotation]);

  /**
   * Sets the amount an image should be scaled.
   *
   * value : number|{magnitude: number, reference: [ScaleReference]}
   * Either a single number representing amount the image should be scaled, or an object with the magnitude and reference.
   *
   * opt_reference : [ScaleReference]
   * The aspect of the video feed which the image is scaled relative to.
   */
  void setScale(value, [String opt_reference]) {
    if (value is! num && value is! Map<String, num>) {
      throw(new ArgumentError("value has be be num or Map"));
      return;
    }
    if (value is num) {
      if(opt_reference != null) {
        _proxy.callMethod("setScale", [value, opt_reference]);
      } else {
        throw(new ArgumentError("If value is num, opt_reference has to be set as well"));
      }
    } else {
      _proxy.callMethod("setScale", [_createParamProxy(value)]);
    }
  }

  /// Sets the image overlay to be visible or not.
  void setVisible(bool visible) => _proxy.callMethod("setVisible", [visible]);
}

/**
 * Object used to control one instance of a sound.
 * Sounds played through this API will automatically be echo-cancelled.
 * Create a Sound using createSound.
 */
class Sound extends ProxyObject {

  AudioResource _audioResource;

  Sound._internal(AudioResource this._audioResource, JsObject proxy) : super._internal(proxy);

  /// Disposes the sound.
  void dispose() => _proxy.callMethod("dispose");

  /// The [AudioResource] used to create this Sound.
  AudioResource getAudioResource() => _audioResource;

  /// The volume, in the range 0-1, of the sound.
  num getVolume() => _proxy.callMethod("getVolume");

  /// Returns true if the sound has been disposed.
  bool isDisposed() => _proxy.callMethod("isDisposed");

  /**
   * Returns true if the sound plays only to the local participant.
   * Returns false if the sound plays to all participants and, if in a Hangout On Air, to broadcast viewers.
   */
  bool isLocalOnly() => _proxy.callMethod("isLocalOnly");

  /// Returns true if the sound will repeat, false otherwise.
  bool isLooped() => _proxy.callMethod("isLooped");

  /// Starts playing the sound.
  void play() => _proxy.callMethod("play");

  /// Sets whether the sound will repeat or not, false otherwise.
  void setLoop(bool loop) => _proxy.callMethod("setLoop", [loop]);

  /// Sets the volume of the sound, in the range 0-1.
  void setVolume(num volume) => _proxy.callMethod("setVolume", [volume]);

  /// Stops the sound if it is currently playing.
  void stop() => _proxy.callMethod("stop");
}

// ****************************
// Events
// ****************************

class FaceTrackingDataChangedHandler extends ManyEventHandler {

  FaceTrackingDataChangedHandler._internal() : super._internal(["av", "effects", "onFaceTrackingDataChanged"], HangoutEvent.FACE_TRACKING_DATA);

  void add(void callback(FaceTrackingData event)) {
    super.add(callback);
  }

  void remove(void callback(FaceTrackingData event)) {
    super.remove(callback);
  }
}

/**
 * The positions of points on the face detected in a video feed.
 * The x-y origin is the center of the frame.
 * "Left" and "right" (such as leftEye) are with respect to how others view the face.
 * Likewise, positive x is to the right as others view the face.
 * The width and height of the feed are each equal to 1.0 unit.
 * Pan, roll, and tilt are specified in radians, where 0 radians is center and positive is to the right from the viewer's perspective.
 */
class FaceTrackingData extends HangoutEvent {

  /// Indicates whether there is a face in the video feed.
  bool hasFace;

  Position leftEye;
  Position leftEyebrowLeft;
  Position leftEyebrowRight;
  Position lowerLip;
  Position mouthCenter;
  Position mouthLeft;
  Position mouthRight;
  Position noseRoot;
  Position noseTip;
  num pan;
  Position rightEye;
  Position rightEyebrowLeft;
  Position rightEyebrowRight;
  num roll;
  num tilt;
  Position upperLip;

  FaceTrackingData._internal(JsObject data) : super._internal() {
    if (data["hasFace"] != null) hasFace = data["hasFace"];
    if (data["leftEye"] != null) leftEye = new Position._internalProxy(data["leftEye"]);
    if (data["leftEyebrowLeft"] != null) leftEyebrowLeft = new Position._internalProxy(data["leftEyebrowLeft"]);
    if (data["leftEyebrowRight"] != null) leftEyebrowRight = new Position._internalProxy(data["leftEyebrowRight"]);
    if (data["lowerLip"] != null) lowerLip = new Position._internalProxy(data["lowerLip"]);
    if (data["mouthCenter"] != null) mouthCenter = new Position._internalProxy(data["mouthCenter"]);
    if (data["mouthLeft"] != null) mouthLeft = new Position._internalProxy(data["mouthLeft"]);
    if (data["mouthRight"] != null) mouthRight = new Position._internalProxy(data["mouthRight"]);
    if (data["noseRoot"] != null) noseRoot = new Position._internalProxy(data["noseRoot"]);
    if (data["noseTip"] != null) noseTip = new Position._internalProxy(data["noseTip"]);
    if (data["pan"] != null) pan = data["pan"];
    if (data["rightEye"] != null) rightEye = new Position._internalProxy(data["rightEye"]);
    if (data["rightEyebrowLeft"] != null) rightEyebrowLeft = new Position._internalProxy(data["rightEyebrowLeft"]);
    if (data["rightEyebrowRight"] != null) rightEyebrowRight = new Position._internalProxy(data["rightEyebrowRight"]);
    if (data["roll"] != null) roll = data["roll"];
    if (data["tilt"] != null) tilt = data["tilt"];
    if (data["upperLip"] != null) upperLip = new Position._internalProxy(data["upperLip"]);
  }
}

class Position {
  num x;
  num y;

  Position._internalProxy(JsObject data) {
    if (data["x"] != null) x = data["x"];
    if (data["y"] != null) y = data["y"];
  }
}

class ResourceLoadHandler extends OnceEventHandler {

  ResourceLoadHandler._internal(JsObject proxy) : super._internalProxy(proxy, HangoutEvent.RESOURCE_LOAD_RESULT);

  void add(void callback(ResourceLoadResult event)) {
    super.add(callback);
  }

  void remove(void callback(ResourceLoadResult event)) {
    super.remove(callback);
  }
}

/// Contains information about the success of a resource load.
class ResourceLoadResult extends HangoutEvent {
  /// True if the load successed, false otherwise.
  bool isLoaded;

  ResourceLoadResult._internal(JsObject data) : super._internal() {
    if (data["isLoaded"] != null) {
      isLoaded = data["isLoaded"];
    } else {
      throw new HangoutAPIException("Invalid return value in onLoad callback");
    }
  }
}


/**
 * Identifiers for the features that can be tracked by a [FaceTrackingOverlay].
 * "Left" and "right" are from how others view the face.
 */
class FaceTrackingFeatureEnum {

  final String LEFT_EYE;
  final String LEFT_EYEBROW_LEFT;
  final String LEFT_EYEBROW_RIGHT;
  final String LOWER_LIP;
  final String MOUTH_CENTER;
  final String MOUTH_LEFT;
  final String MOUTH_RIGHT;
  final String NOSE_ROOT;
  final String NOSE_TIP;
  final String RIGHT_EYE;
  final String RIGHT_EYEBROW_LEFT;
  final String RIGHT_EYEBROW_RIGHT;
  final String UPPER_LIP;

  FaceTrackingFeatureEnum._internal(JsObject data) :
    LEFT_EYE = data["LEFT_EYE"],
    LEFT_EYEBROW_LEFT = data["LEFT_EYEBROW_LEFT"],
    LEFT_EYEBROW_RIGHT = data["LEFT_EYEBROW_RIGHT"],
    LOWER_LIP = data["LOWER_LIP"],
    MOUTH_CENTER = data["MOUTH_CENTER"],
    MOUTH_LEFT = data["MOUTH_LEFT"],
    MOUTH_RIGHT = data["MOUTH_RIGHT"],
    NOSE_ROOT = data["NOSE_ROOT"],
    NOSE_TIP = data["NOSE_TIP"],
    RIGHT_EYE = data["RIGHT_EYE"],
    RIGHT_EYEBROW_LEFT = data["RIGHT_EYEBROW_LEFT"],
    RIGHT_EYEBROW_RIGHT = data["RIGHT_EYEBROW_RIGHT"],
    UPPER_LIP = data["UPPER_LIP"];
}


/// Possible states of a resource.
class ResourceStateEnum {

  final String DISPOSED;
  final String ERROR;
  final String LOADING;
  final String LOADED;

  ResourceStateEnum._internal(JsObject data) :
    DISPOSED = data["DISPOSED"],
    ERROR = data["ERROR"],
    LOADING = data["LOADING"],
    LOADED = data["LOADED"];

}

/**
 * Possible values for the aspect of the video feed that an [Overlay] is scaled relative to.
 */
class ScaleReferenceEnum {

  final String HEIGHT;
  final String WIDTH;

  ScaleReferenceEnum._internal(JsObject data) :
    HEIGHT = data["HEIGHT"],
    WIDTH = data["WIDTH"];

}