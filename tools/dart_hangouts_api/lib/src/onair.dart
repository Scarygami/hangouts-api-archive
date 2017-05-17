part of hangouts_api;

/// Provides ability for interacting with Hangouts On Air.
class HangoutOnair {

  BroadcastDisplayModeEnum _broadcastDisplayMode;

  /// Determines whether the broadcast video shows or hides the filmstrip
  BroadcastDisplayModeEnum get BroadcastDisplayMode => _broadcastDisplayMode;

  AudioNotificationsDefaultMuteChangedHandler _onAudioNotificationsDefaultMuteChanged;
  BroadcastDisplayModeChangedHandler _onBroadcastDisplayModeChanged;
  BroadcastingChangedHandler _onBroadcastingChanged;
  DisplayedParticipantInBroadcastChangedHandler _onDisplayedParticipantInBroadcastChanged;
  NewParticipantInBroadcastChangedHandler _onNewParticipantInBroadcastChanged;
  YouTubeLiveIdReadyHandler _onYouTubeLiveIdReady;

  /// Handles callbacks to be called when the audio notifications are muted or unmuted for all new participants in a Hangout On Air.
  AudioNotificationsDefaultMuteChangedHandler get onAudioNotificationsDefaultMuteChanged => _onAudioNotificationsDefaultMuteChanged;

  /// Handles callbacks to be called when the broadcast display mode changes.
  BroadcastDisplayModeChangedHandler get onBroadcastDisplayModeChanged => _onBroadcastDisplayModeChanged;

  /// Handles callbacks to be called when the hangout starts or stops broadcasting.
  BroadcastingChangedHandler get onBroadcastingChanged => _onBroadcastingChanged;

  /// Handles callbacks to be called when the participant displayed in the broadcast changes.
  DisplayedParticipantInBroadcastChangedHandler get onDisplayedParticipantInBroadcastChanged => _onDisplayedParticipantInBroadcastChanged;

  /// Handles callbacks to be called when the setting changes for whether new participants are in the Hangout On Air by default.
  NewParticipantInBroadcastChangedHandler get onNewParticipantInBroadcastChanged => _onNewParticipantInBroadcastChanged;

  /// Handles callbacks to be called when the YouTube Live ID is set for a Hangout On Air.
  YouTubeLiveIdReadyHandler get onYouTubeLiveIdReady => _onYouTubeLiveIdReady;

  HangoutOnair._internal() {
    _onAudioNotificationsDefaultMuteChanged = new AudioNotificationsDefaultMuteChangedHandler._internal();
    _onBroadcastDisplayModeChanged = new BroadcastDisplayModeChangedHandler._internal();
    _onBroadcastingChanged = new BroadcastingChangedHandler._internal();
    _onNewParticipantInBroadcastChanged = new NewParticipantInBroadcastChangedHandler._internal();
    _onYouTubeLiveIdReady = new YouTubeLiveIdReadyHandler._internal();
    _onDisplayedParticipantInBroadcastChanged = new DisplayedParticipantInBroadcastChangedHandler._internal();

    var data = context["gapi"]["hangout"]["onair"]["BroadcastDisplayMode"];
    _broadcastDisplayMode = new BroadcastDisplayModeEnum._internal(data);
  }

  /// Sets the broadcast screen to show or hide the filmstrip.
  void setBroadcastDisplayMode(int broadcastDisplayMode) => _makeVoidCall(["onair", "setBroadcastDisplayMode"], [broadcastDisplayMode]);

  /// Gets whether the broadcast screen shows or hides the filmstrip.
  int getBroadcastDisplayMode() => _makeNumCall(["onair", "setBroadcastDisplayMode"]);

  /**
   * Returns the YouTube Live ID for the Hangout On Air.
   * Returns null if the ID is not available or the hangout is not a broadcast hangout.
   */
  String getYouTubeLiveId() => _makeStringCall(["onair", "getYouTubeLiveId"]);

  /// Returns true if the hangout is a Hangout On Air which is currently broadcasting, false otherwise.
  bool isBroadcasting() => _makeBoolCall(["onair", "isBroadcasting"]);

  /// Returns true if new participants to the hangout are included in the Hangout On Air broadcast by default, false otherwise.
  bool isNewParticipantInBroadcast() => _makeBoolCall(["onair", "isNewParticipantInBroadcast"]);

  /**
   * Returns true if the hangout is a Hangout On Air, false otherwise.
   * Note that this does not indicate that the hangout is currently broadcasting — see isBroadcasting for that.
   * This value may change from false to true when the YouTubeLiveIdReady event fires.
   */
  bool isOnAirHangout() => _makeBoolCall(["onair", "isOnAirHangout"]);

  ///
  bool areAudioNotificationsDefaultMuted() => _makeBoolCall(["onair", "areAudioNotificationsDefaultMuted"]);

  /**
   * Sets whether audio notifications are muted for all new participants in the Hangout On Air broadcast.
   * Sounds include other users joining and departing, ringing telephone calls,
   * and all other audio originating from the Hangout itself (as opposed to audio originating from participants).
   * Sound effects will not be muted.
   * This call fails for Hangouts that are not On Air, or if the local participant is not the broadcaster of the hangout.
   */
  void setAudioNotificationsDefaultMute(bool areNotificationsMuted) => _makeVoidCall(["onair", "setAudioNotificationsDefaultMute"], [areNotificationsMuted]);

  /**
   * Sets whether the given participant is included in the Hangout On Air broadcast.
   * This call fails for hangouts that are not On Air, or if the local participant is not the broadcaster of the hangout.
   */
  void setParticipantInBroadcast(String participantId, bool isInBroadcast) => _makeVoidCall(["onair", "setParticipantInBroadcast"], [participantId, isInBroadcast]);

  /**
   * Sets whether new participants in the hangout are included in the Hangout On Air broadcast by default.
   * This call fails for hangouts that are not On Air, or if the local participant is not the broadcaster of the hangout.
   */
  void setNewParticipantInBroadcast(bool isInBroadcast) => _makeVoidCall(["onair", "setNewParticipantInBroadcast"], [isInBroadcast]);

  /**
   * Gets the participant ID of the participant who is displayed in the broadcast.
   * This call fails for hangouts that are not On Air.
   * Example: 'hangout65A4C551_ephemeral.id.google.com^354e9d1ed0'
   */
  String getDisplayedParticipantInBroadcast() => _makeStringCall(["onair", "getDisplayedParticipantInBroadcast"]);

  /**
   * Sets the the participant to be displayed in the broadcast.
   * This call fails for hangouts that are not On Air, or if the local participant is not the broadcaster of the hangout.
   */
  void setDisplayedParticipantInBroadcast(String participantId) => _makeVoidCall(["onair", "setDisplayedParticipantInBroadcast"], [participantId]);

  /**
   * Clears the participant chosen to be displayed in the broadcast, returning the display of broadcast participants to normal behavior.
   * This call fails for hangouts that are not On Air, or if the local participant is not the broadcaster of the hangout.
   * This call also fails if this app did not make the most recent change to the participant shown in the broadcast.
   */
  void clearDisplayedParticipantInBroadcast() => _makeVoidCall(["onair", "clearDisplayedParticipantInBroadcast"]);
}


class AudioNotificationsDefaultMuteChangedHandler extends ManyEventHandler {

  AudioNotificationsDefaultMuteChangedHandler._internal() : super._internal(["onair", "onAudioNotificationsDefaultMuteChanged"], HangoutEvent.AUDIO_NOTIFICATIONS_DEFAULT_MUTE_CHANGED_EVENT);

  void add(void callback(AudioNotificationsDefaultMuteChangedEvent event)) {
    super.add(callback);
  }

  void remove(void callback(AudioNotificationsDefaultMuteChangedEvent event)) {
    super.remove(callback);
  }
}

/// An event fired when audio notifications are muted or unmuted for all new participants in a Hangout On Air.
class AudioNotificationsDefaultMuteChangedEvent extends HangoutEvent {

  /// Whether audio notifications are muted for all new participants.
  bool areNotificationsMuted;

  AudioNotificationsDefaultMuteChangedEvent._internal(JsObject data) : super._internal() {
    if (data["areNotificationsMuted"] != null) {
      areNotificationsMuted = data["areNotificationsMuted"];
    }
  }

}


class BroadcastDisplayModeChangedHandler extends ManyEventHandler {

  BroadcastDisplayModeChangedHandler._internal() : super._internal(["onair", "onBroadcastDisplayModeChanged"], HangoutEvent.BROADCAST_DISPLAY_MODE_CHANGED_EVENT);

  void add(void callback(BroadcastDisplayModeChangedEvent event)) {
    super.add(callback);
  }

  void remove(void callback(BroadcastDisplayModeChangedEvent event)) {
    super.remove(callback);
  }
}

/// Provides information about when to broadcast in full screen.
class BroadcastDisplayModeChangedEvent extends HangoutEvent {

  /// Indicates when to broadcast in full screen.
  int broadcastDisplayMode;

  BroadcastDisplayModeChangedEvent._internal(JsObject data) : super._internal() {
    if (data["broadcastDisplayMode"] != null) {
      broadcastDisplayMode = data["broadcastDisplayMode"];
    }
  }

}


class BroadcastingChangedHandler extends ManyEventHandler {

  BroadcastingChangedHandler._internal() : super._internal(["onair", "onBroadcastingChanged"], HangoutEvent.BROADCASTING_CHANGED_EVENT);

  void add(void callback(BroadcastingChangedEvent event)) {
    super.add(callback);
  }

  void remove(void callback(BroadcastingChangedEvent event)) {
    super.remove(callback);
  }
}

/// Contains information about whether the hangout is broadcasting.
class BroadcastingChangedEvent extends HangoutEvent {

  /// Indicates whether the hangout is broadcasting.
  bool isBroadcasting;

  BroadcastingChangedEvent._internal(JsObject data) : super._internal() {
    if (data["isBroadcasting"] != null) {
      isBroadcasting = data["isBroadcasting"];
    } else {
      throw new HangoutAPIException("Invalid return value in onBroadcastingChanged callback");
    }
  }
}


class DisplayedParticipantInBroadcastChangedHandler extends ManyEventHandler {

  DisplayedParticipantInBroadcastChangedHandler._internal() : super._internal(["onair", "onDisplayedParticipantInBroadcastChangedHandler"], HangoutEvent.DISPLAYED_PARTICIPANT_IN_BROADCAST_CHANGED_EVENT);

  void add(void callback(DisplayedParticipantInBroadcastChangedEvent event)) {
    super.add(callback);
  }

  void remove(void callback(DisplayedParticipantInBroadcastChangedEvent event)) {
    super.remove(callback);
  }
}

/// Contains information about whether new participants will be included in the Hangout On Air broadcast by default.
class DisplayedParticipantInBroadcastChangedEvent extends HangoutEvent {

  /// Indicates whether new participants are in the broadcast by default.
  String displayedParticipant;

  DisplayedParticipantInBroadcastChangedEvent._internal(JsObject data) : super._internal() {
    if (data["displayedParticipant"] != null) {
      displayedParticipant = data["displayedParticipant"];
    } else {
      throw new HangoutAPIException("Invalid return value in onDisplayedParticipantInBroadcastChanged callback");
    }
  }
}


class NewParticipantInBroadcastChangedHandler extends ManyEventHandler {

  NewParticipantInBroadcastChangedHandler._internal() : super._internal(["onair", "onNewParticipantInBroadcastChanged"], HangoutEvent.NEW_PARTICIPANT_IN_BROADCAST_CHANGED_EVENT);

  void add(void callback(NewParticipantInBroadcastChangedEvent event)) {
    super.add(callback);
  }

  void remove(void callback(NewParticipantInBroadcastChangedEvent event)) {
    super.remove(callback);
  }
}

/// Contains information about whether new participants will be included in the Hangout On Air broadcast by default.
class NewParticipantInBroadcastChangedEvent extends HangoutEvent {

  /// Indicates whether new participants are in the broadcast by default.
  bool isNewParticipantInBroadcast;

  NewParticipantInBroadcastChangedEvent._internal(JsObject data) : super._internal() {
    if (data["isNewParticipantInBroadcast"] != null) {
      isNewParticipantInBroadcast = data["isNewParticipantInBroadcast"];
    } else {
      throw new HangoutAPIException("Invalid return value in onNewParticipantInBroadcastChanged callback");
    }
  }
}


class YouTubeLiveIdReadyHandler extends OnceEventHandler {

  YouTubeLiveIdReadyHandler._internal() : super._internal(["onair", "onYouTubeLiveIdReady"], HangoutEvent.YOUTUBE_LIVEID_READY_EVENT);

  void add(void callback(YouTubeLiveIdReadyEvent event)) {
    super.add(callback);
  }

  void remove(void callback(YouTubeLiveIdReadyEvent event)) {
    super.remove(callback);
  }
}

/// Contains information signaling the YouTube Live ID for a Hangout On Air is available.
class YouTubeLiveIdReadyEvent extends HangoutEvent {

  /// The YouTube Live ID for the Hangout On Air.
  String youTubeLiveId;

  YouTubeLiveIdReadyEvent._internal(JsObject data) : super._internal() {
    if (data["youTubeLiveId"] != null) {
      youTubeLiveId = data["youTubeLiveId"];
    } else {
      throw new HangoutAPIException("Invalid return value in onYouTubeLiveIdReady callback");
    }
  }
}


/// Determines whether the broadcast video shows or hides the filmstrip
class BroadcastDisplayModeEnum {

  /// Always display main feed only.
  final int FOCUSED_FEED_ONLY;

  /// Always display main feed and filmstrip.
  final int HANGOUT_VIEW;

  /// Automatically hide filmstrip when there is one user.
  final int AUTO;

  BroadcastDisplayModeEnum._internal(JsObject data) :
    FOCUSED_FEED_ONLY = data["FOCUSED_FEED_ONLY"],
    HANGOUT_VIEW = data["HANGOUT_VIEW"],
    AUTO = data["AUTO"];

}