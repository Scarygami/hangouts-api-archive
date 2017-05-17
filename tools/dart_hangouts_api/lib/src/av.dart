part of hangouts_api;


/// Provides ability to control hangout microphones, cameras, speakers and volume levels.
class HangoutAv {

  HangoutAvEffects _effects;

  /// Provides ability to add sound effects and attach image overlays to faces.
  HangoutAvEffects get effects => _effects;


  CameraMuteHandler _onCameraMute;
  HasCameraHandler _onHasCamera;
  HasMicrophoneHandler _onHasMicrophone;
  HasSpeakersHandler _onHasSpeakers;
  LocalAudioNotificationsMuteChangedHandler _onLocalAudioNotificationsMuteChanged;
  LocalParticipantVideoMirroredChangedHandler _onLocalParticipantVideoMirroredChanged;
  MicrophoneMuteHandler _onMicrophoneMute;
  VolumesChangedHandler _onVolumesChanged;

  /// Handles callbacks to be called when the local participant starts or stops sending video.
  CameraMuteHandler get onCameraMute => _onCameraMute;

  /**
   * Handles callbacks to be called when the local participant activates or deactivates their camera.
   * "Activate" means the camera is connected and available (whether muted or not muted).
   */
  HasCameraHandler get onHasCamera => _onHasCamera;

  /**
   * Handles callbacks to be called when the local participant activates or deactivates their mic.
   * "Activate" means the microphone is connected and available (whether muted or not muted).
   */
  HasMicrophoneHandler get onHasMicrophone => _onHasMicrophone;

  /**
   * Handles callbacks to be called when the local participant activates or deactivates their audio speakers.
   * "Activate" means the speakers are connected and available (whether the volume is turned up or down).
   */
  HasSpeakersHandler get onHasSpeakers => _onHasSpeakers;

  /// Handles callbacks to be called when the localAudioNotificationsMute changes.
  LocalAudioNotificationsMuteChangedHandler get onLocalAudioNotificationsMuteChanged => _onLocalAudioNotificationsMuteChanged;

  /// Handles callbacks to be called when the mirrored state of the local participant's video changes.
  LocalParticipantVideoMirroredChangedHandler get onLocalParticipantVideoMirroredChanged => _onLocalParticipantVideoMirroredChanged;

  /// Handles callbacks to be called when the microphone mute state for the local participant changes.
  MicrophoneMuteHandler get onMicrophoneMute => _onMicrophoneMute;

  /**
   * Handles callbacks to be called when the audio volume levels at the source changes for any participant.
   * The argument to the callback is an [VolumesChangedEvent] that holds the new volume levels for all participants.
   */
  VolumesChangedHandler get onVolumesChanged => _onVolumesChanged;

  HangoutAv._internal() {
    _effects = new HangoutAvEffects._internal();

    _onCameraMute = new CameraMuteHandler._internal();
    _onHasCamera = new HasCameraHandler._internal();
    _onHasMicrophone = new HasMicrophoneHandler._internal();
    _onHasSpeakers = new HasSpeakersHandler._internal();
    _onLocalAudioNotificationsMuteChanged = new LocalAudioNotificationsMuteChangedHandler._internal();
    _onLocalParticipantVideoMirroredChanged = new LocalParticipantVideoMirroredChangedHandler._internal();
    _onMicrophoneMute = new MicrophoneMuteHandler._internal();
    _onVolumesChanged = new VolumesChangedHandler._internal();
  }

  /// Removes avatar image displayed over the video feed.
  void clearAvatar(String participantId) => _makeVoidCall(["av", "clearAvatar"], [participantId]);

  /// Gets whether audio notifications are muted for the local participant.
  bool areLocalAudioNotificationsMuted() => _makeBoolCall(["av", "areLocalAudioNotificationsMuted"]);

  /**
   *  Gets the audio level for a participant as set by [setParticipantAudioLevel].
   *  Returns a two-element array where the first element is the level of the left audio channel and the second element is the level of the right audio channel.
   */
  List<num> getParticipantAudioLevel(String participantId) {
    var data = _makeProxyCall(["av", "getParticipantAudioLevel"], [participantId]);
    var level = null;
    if (data != null) {
      level = JSON.decode(context["JSON"]["stringify"].apply([data]));
    }
    return level;
  }

  /// Gets the URL for the avatar image for the given participant. Returns null if no avatar image is set for the participant.
  String getAvatar(String participantId) => _makeStringCall(["av", "getAvatar"], [participantId]);

  /// Returns true if the local participant's camera is currently sending video, false otherwise.
  bool getCameraMute() => _makeBoolCall(["av", "getCameraMute"]);

  /// Returns true if the microphone is muted for the local participant, false otherwise.
  bool getMicrophoneMute() => _makeBoolCall(["av", "getMicrophoneMute"]);

  /// Gets the current audio volume for the given participant, a number from 0 to 5, inclusive.
  num getParticipantVolume(String participantId) => _makeNumCall(["av", "getParticipantVolume"], [participantId]);

  /**
   * Gets the current audio volume level for all participants.
   * Returns a map with key/value pairs where the key is the participant ID and the value is the volume for that participant.
   * The volume is a number from 0 to 5, inclusive.
   */
  Map<String, num> getVolumes() {
    var data = _makeProxyCall(["av", "getVolumes"]);
    var level = null;
    if (data != null) {
      level = JSON.decode(context["JSON"]["stringify"].apply([data]));
    }
    return level;
  }

  /// Returns true if the local participant has an active camera, false otherwise.
  bool hasCamera() => _makeBoolCall(["av", "hasCamera"]);

  /// Returns true if the local participant has a working mic, false otherwise.
  bool hasMicrophone() => _makeBoolCall(["av", "hasMicrophone"]);

  /// Returns true if the local participant has working audio speakers, false otherwise.
  bool hasSpeakers() => _makeBoolCall(["av", "hasSpeakers"]);

  /// Returns true if the video of the local participant appears mirrored to the local participant, false otherwise.
  bool isLocalParticipantVideoMirrored() => _makeBoolCall(["av", "isLocalParticipantVideoMirrored"]);

  /// Returns true if the participant's audio is muted for the local participant, false otherwise.
  bool isParticipantAudible(String participantId) => _makeBoolCall(["av", "isParticipantAudible"], [participantId]);

  /// Returns true if the participant's video is muted for the local participant, false otherwise.
  bool isParticipantVisible(String participantId) => _makeBoolCall(["av", "isParticipantVisible"], [participantId]);

  /// Mutes a participant's microphone.
  void muteParticipantMicrophone(String participantId) => _makeVoidCall(["av", "muteParticipantMicrophone"], [participantId]);

  /**
   * Sets whether audio notifications are muted for the local participant.
   * Sounds include other users joining and departing, ringing telephone calls,
   * and all other audio originating from the Hangout itself (as opposed to audio
   * originating from participants). Sound effects will not be muted.
   */
  void setLocalAudioNotificationsMute(bool areNotificationsMuted) => _makeVoidCall(["av", "setLocalAudioNotificationsMute"], [areNotificationsMuted]);

  /// Mutes a participant's microphone.
  void setLocalParticipantVideoMirrored(bool mirrored) => _makeVoidCall(["av", "setLocalParticipantVideoMirrored"], [mirrored]);


  /**
   * Sets the audio level of a participant as heard by only the local participant.
   * The audio level for a participant is in the range 0-10 with 1 being the default,
   * a number from 0 to 1 indicating that the audio should be quieter than the default and a number
   * from 1 to 10 indicating that the audio should be louder than the default.
   * The audio level can also be set independently for the right and left audio channels.
   */
  void setParticipantAudioLevel(String participantId, audioLevel) {
    if (audioLevel is! num && audioLevel is! List<num>) {
      throw(new ArgumentError("audioLevel has be be num or List<num>"));
      return;
    }
    _makeVoidCall(["av", "setParticipantAudioLevel"], [participantId, audioLevel]);
  }

  /**
   * Shows an image over the video feed for a participant.
   * Note this affects only the view seen by the local participant.
   * The other participants in the hangout will still see the video feed for the given participant.
   */
  void setAvatar(String participantId, String imageUrl) => _makeVoidCall(["av", "setAvatar"], [participantId, imageUrl]);

  /// Starts or stops the local participant from sending video to the other hangout participants.
  void setCameraMute(bool muted) => _makeVoidCall(["av", "setCameraMute"], [muted]);

  /// Reverts the camera mute state to the last state set by the local participant.
  void clearCameraMute() => _makeVoidCall(["av", "clearCameraMute"]);

  /// Mutes or unmutes the microphone for the local participant.
  void setMicrophoneMute(bool muted) => _makeVoidCall(["av", "setMicrophoneMute"], [muted]);

  /// Reverts the microphone mute state to the last state set by the local participant.
  void clearMicrophoneMute() => _makeVoidCall(["av", "clearMicrophoneMute"]);

  void setParticipantAudible(String participantId, bool audible) => _makeVoidCall(["av", "setParticipantAudible"], [participantId, audible]);

  void setParticipantVisible(String participantId, bool visible) => _makeVoidCall(["av", "setParticipantVisible"], [participantId, visible]);
}

// ****************************
// Events
// ****************************

class CameraMuteHandler extends ManyEventHandler {

  CameraMuteHandler._internal() : super._internal(["av", "onCameraMute"], HangoutEvent.CAMERA_MUTE_EVENT);

  void add(void callback(CameraMuteEvent event)) {
    super.add(callback);
  }

  void remove(void callback(CameraMuteEvent event)) {
    super.remove(callback);
  }
}

/// Contains information about the muting of the video from the local camera.
class CameraMuteEvent extends HangoutEvent {

  /// Indicates whether the local participant is sending video.
  bool isCameraMute;

  CameraMuteEvent._internal(JsObject data) : super._internal() {
    if (data["isCameraMute"] != null) {
      isCameraMute = data["isCameraMute"];
    } else {
      throw new HangoutAPIException("Invalid return value in onCameraMute callback");
    }
  }
}

class HasCameraHandler extends ManyEventHandler {

  HasCameraHandler._internal() : super._internal(["av", "onHasCamera"], HangoutEvent.HAS_CAMERA_EVENT);

  void add(void callback(HasCameraEvent event)) {
    super.add(callback);
  }

  void remove(void callback(HasCameraEvent event)) {
    super.remove(callback);
  }
}

/// Contains information about the local camera being activated.
class HasCameraEvent extends HangoutEvent {

  /// Indicates whether the local participant's camera is activated.
  bool hasCamera;

  HasCameraEvent._internal(JsObject data) : super._internal() {
    if (data["hasCamera"] != null) {
      hasCamera = data["hasCamera"];
    } else {
      throw new HangoutAPIException("Invalid return value in onHasCamera callback");
    }
  }
}

class HasMicrophoneHandler extends ManyEventHandler {

  HasMicrophoneHandler._internal() : super._internal(["av", "onHasMicrophone"], HangoutEvent.HAS_MICROPHONE_EVENT);

  void add(void callback(HasMicrophoneEvent event)) {
    super.add(callback);
  }

  void remove(void callback(HasMicrophoneEvent event)) {
    super.remove(callback);
  }
}

/// Contains information about the activation of the local microphone.
class HasMicrophoneEvent extends HangoutEvent {

  /// Indicates whether the local participant's microphone is activated.
  bool hasMicrophone;

  HasMicrophoneEvent._internal(JsObject data) : super._internal() {
    if (data["hasMicrophone"] != null) {
      hasMicrophone = data["hasMicrophone"];
    } else {
      throw new HangoutAPIException("Invalid return value in onHasMicrophone callback");
    }
  }
}

class HasSpeakersHandler extends ManyEventHandler {

  HasSpeakersHandler._internal() : super._internal(["av", "onHasSpeakers"], HangoutEvent.HAS_SPEAKERS_EVENT);

  void add(void callback(HasSpeakersEvent event)) {
    super.add(callback);
  }

  void remove(void callback(HasSpeakersEvent event)) {
    super.remove(callback);
  }
}

/// Contains information about the activation of the local audio speakers.
class HasSpeakersEvent extends HangoutEvent {

  /// Indicates whether the local participant's audio speakers are activated.
  bool hasSpeakers;

  HasSpeakersEvent._internal(JsObject data) : super._internal() {
    if (data["hasSpeakers"] != null) {
      hasSpeakers = data["hasSpeakers"];
    } else {
      throw new HangoutAPIException("Invalid return value in onHasSpeakers callback");
    }
  }
}

class LocalAudioNotificationsMuteChangedHandler extends ManyEventHandler {

  LocalAudioNotificationsMuteChangedHandler._internal() : super._internal(["av", "onLocalAudioNotificationsMuteChanged"], HangoutEvent.LOCAL_AUDIO_NOTIFICATIONS_MUTE_CHANGED_EVENT);

  void add(void callback(LocalAudioNotificationsMuteChangedEvent event)) {
    super.add(callback);
  }

  void remove(void callback(LocalAudioNotificationsMuteChangedEvent event)) {
    super.remove(callback);
  }
}

/// An event fired when localAudioNotificationsMute is changed.
class LocalAudioNotificationsMuteChangedEvent extends HangoutEvent {

  /// Whether notifications are muted for the local participant
  bool areNotificationsMuted;

  LocalAudioNotificationsMuteChangedEvent._internal(JsObject data) : super._internal() {
    if (data["areNotificationsMuted"] != null) {
      areNotificationsMuted = data["areNotificationsMuted"];
    } else {
      throw new HangoutAPIException("Invalid return value in onLocalAudioNotificationsMuteChanged callback");
    }
  }
}

class LocalParticipantVideoMirroredChangedHandler extends ManyEventHandler {

  LocalParticipantVideoMirroredChangedHandler._internal() : super._internal(["av", "onLocalParticipantVideoMirroredChanged"], HangoutEvent.LOCAL_PARTICIPANT_VIDEO_MIRRORED_CHANGED_EVENT);

  void add(void callback(LocalParticipantVideoMirroredChangedEvent event)) {
    super.add(callback);
  }

  void remove(void callback(LocalParticipantVideoMirroredChangedEvent event)) {
    super.remove(callback);
  }
}

/// Contains information about whether the video for the local participant appears mirrored for the local participant.
class LocalParticipantVideoMirroredChangedEvent extends HangoutEvent {

  /// Whether the video of the local participant appears mirrored for the local participant.
  bool isMirrored;

  LocalParticipantVideoMirroredChangedEvent._internal(JsObject data) : super._internal() {
    if (data["isMirrored"] != null) {
      isMirrored = data["isMirrored"];
    } else {
      throw new HangoutAPIException("Invalid return value in onLocalParticipantVideoMirroredChanged callback");
    }
  }
}

class MicrophoneMuteHandler extends ManyEventHandler {

  MicrophoneMuteHandler._internal() : super._internal(["av", "onMicrophoneMute"], HangoutEvent.MICROPHONE_MUTE_EVENT);

  void add(void callback(MicrophoneMuteEvent event)) {
    super.add(callback);
  }

  void remove(void callback(MicrophoneMuteEvent event)) {
    super.remove(callback);
  }
}

/// Contains information about muting the local microphone.
class MicrophoneMuteEvent extends HangoutEvent {

  /// Indicates whether the local participant's microphone is muted.
  bool isMicrophoneMute;

  MicrophoneMuteEvent._internal(JsObject data) : super._internal() {
    if (data["isMicrophoneMute"] != null) {
      isMicrophoneMute = data["isMicrophoneMute"];
    } else {
      throw new HangoutAPIException("Invalid return value in onMicrophoneMute callback");
    }
  }
}

class VolumesChangedHandler extends ManyEventHandler {

  VolumesChangedHandler._internal() : super._internal(["av", "onVolumesChanged"], HangoutEvent.VOLUMES_CHANGED_EVENT);

  void add(void callback(VolumesChangedEvent event)) {
    super.add(callback);
  }

  void remove(void callback(VolumesChangedEvent event)) {
    super.remove(callback);
  }
}

/// Contains information about the muting of the video from the local camera.
class VolumesChangedEvent extends HangoutEvent {

  /// Indicates whether the local participant is sending video.
  Map<String, num> volumes;

  VolumesChangedEvent._internal(JsObject data) : super._internal() {
    if (data["volumes"] != null) {
      volumes = JSON.decode(context["JSON"]["stringify"].apply([data["volumes"]]));
    } else {
      throw new HangoutAPIException("Invalid return value in onVolumesChanged callback");
    }
  }
}
