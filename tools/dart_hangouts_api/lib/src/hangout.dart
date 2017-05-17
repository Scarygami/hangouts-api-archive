part of hangouts_api;

/**
 * Main Hangouts API class:
 * Provides basic information such as the list of participants,
 * the locale, and whether the app is initialized and visible.
 */
class Hangout {

  HangoutAv _av;
  HangoutData _data;
  HangoutLayout _layout;
  HangoutOnair _onair;

  /// Provides ability to control hangout microphones, cameras, speakers and volume levels, as well as effects
  HangoutAv get av => _av;

  /// Provides functions for sharing data (getting and setting state) between participants in a hangout.
  HangoutData get data => _data;

  /// Provides ability to set UI layout elements such as the video feed, chat pane, and notices.
  HangoutLayout get layout => _layout;

  /// Provides ability for interacting with Hangouts On Air
  HangoutOnair get onair => _onair;

  ApiReadyHandler _onApiReady;
  AppVisibleHandler _onAppVisible;
  EnabledParticipantsChangedHandler _onEnabledParticipantsChanged;
  ParticipantsAddedHandler _onParticipantsAdded;
  ParticipantsChangedHandler _onParticipantsChanged;
  ParticipantsDisabledHandler _onParticipantsDisabled;
  ParticipantsEnabledHandler _onParticipantsEnabled;
  ParticipantsRemovedHandler _onParticipantsRemoved;
  PreferredLocaleChangedHandler _onPreferredLocaleChanged;
  PublicChangedHandler _onPublicChanged;
  TopicChangedHandler _onTopicChanged;

  /**
   * Handles callbacks to be called when the gapi.hangout API becomes ready to use.
   * If the API is already initialized, the callback will be called at the next event dispatch.
   */
  ApiReadyHandler get onApiReady => _onApiReady;

  /// Handles callbacks to be called  when the app is shown or hidden.
  AppVisibleHandler get onAppVisible => _onAppVisible;

  /**
   * Handles callbacks to be called whenever the set of participants who are running this app changes.
   * The argument to the callback is an [EnabledParticipantsChangedEvent] that holds all participants who have enabled the app since the last time the event fired.
   */
  EnabledParticipantsChangedHandler get onEnabledParticipantsChanged => _onEnabledParticipantsChanged;

  /**
   * Handles callbacks to be called whenever participants join the hangout.
   * The argument to the callback is an [ParticipantsAddedEvent] that holds the particpants who have joined since the last time the event fired.
   */
  ParticipantsAddedHandler get onParticipantsAdded => _onParticipantsAdded;

  /**
   * Handles callbacks to be called whenever there is any change in the participants in the hangout.
   * The argument to the callback is an [ParticipantsChangedEvent] that holds holds the participants currently in the hangout.
   */
  ParticipantsChangedHandler get onParticipantsChanged => _onParticipantsChanged;

  /**
   * Handles callbacks to be called whenever a participant stops running this app.
   * The argument to the callback is an [ParticipantsDisabledEvent] that holds the participants who have stopped running this app since the last time the event fired.
   */
  ParticipantsDisabledHandler get onParticipantsDisabled => _onParticipantsDisabled;

  /**
   * Handles callbacks to be called whenever a participant in the hangout starts running this app.
   * The argument to the callback is an [ParticipantsEnabledEvent] that holds the set of participants who have started running this app since the last time the event fired.
   */
  ParticipantsEnabledHandler get onParticipantsEnabled => _onParticipantsEnabled;

  /**
   * Handles callbacks to be called whenever participants leave the hangout.
   * The argument to the callback is an [ParticipantsRemovedEvent] that holds the participants who have left since the last time the event fired.
   */
  ParticipantsRemovedHandler get onParticipantsRemoved => _onParticipantsRemoved;

  /**
   * Handles callbacks to be called when the hangout's preferred locale changes.
   */
  PreferredLocaleChangedHandler get onPreferredLocaleChanged => _onPreferredLocaleChanged;

  /**
   * Handles callbacks to be called when the hangout becomes public. A hangout can change only from private to public.
   */
  PublicChangedHandler get onPublicChanged => _onPublicChanged;

  /**
   * Handles callbacks to be called when the hangout topic changes.
   */
  TopicChangedHandler get onTopicChanged => _onTopicChanged;

  Hangout() {
    try {
      var c = context["gapi"]["hangout"];
    } on NoSuchMethodError {
      throw new HangoutAPIException("Hangout API not available, please make sure that https://plus.google.com/hangouts/_/api/dev/hangout.js is loaded.");
      return;
    }

    _av = new HangoutAv._internal();
    _data = new HangoutData._internal();
    _layout = new HangoutLayout._internal();
    _onair = new HangoutOnair._internal();

    _onApiReady = new ApiReadyHandler._internal();
    _onAppVisible = new AppVisibleHandler._internal();
    _onEnabledParticipantsChanged = new EnabledParticipantsChangedHandler._internal();
    _onParticipantsAdded = new ParticipantsAddedHandler._internal();
    _onParticipantsChanged = new ParticipantsChangedHandler._internal();
    _onParticipantsDisabled = new ParticipantsDisabledHandler._internal();
    _onParticipantsEnabled = new ParticipantsEnabledHandler._internal();
    _onParticipantsRemoved = new ParticipantsRemovedHandler._internal();
    _onPreferredLocaleChanged = new PreferredLocaleChangedHandler._internal();
    _onPublicChanged = new PublicChangedHandler._internal();
    _onTopicChanged = new TopicChangedHandler._internal();
  }

  /// Gets the participants who are running the app.
  List<Participant> getEnabledParticipants() {
    var data = _makeProxyCall(["getEnabledParticipants"]);
    var participants = new List<Participant>();
    for (var i = 0; i < data.length; i++) {
      var proxy = data[i];
      if (proxy != null) participants.add(new Participant._internal(proxy));
    }
    return participants;
  }

  /**
   * Gets the URL for the hangout.
   * Example URL: 'https://talkgadget.google.com/hangouts/_/1b8d9e10742f576bc994e18866ea'
   */
  String getHangoutUrl() => _makeStringCall(["getHangoutUrl"]);

  /**
   * Gets an identifier for the hangout guaranteed to be unique for the hangout's duration.
   * The API makes no other guarantees about this identifier.
   * Example of hangout ID: 'muvc-private-chat-99999a93-6273-390d-894a-473226328d79@groupchat.google.com'
   */
  String getHangoutId() => _makeStringCall(["getHangoutId"]);

  /**
   * Gets the locale for the local participant.
   * Example: 'en'
   */
  String getLocalParticipantLocale() => _makeStringCall(["getLocalParticipantLocale"]);

  /**
   * Gets the preferred locale for the hangout. The user can set this locale prior to starting a hangout.
   * It may differ from gapi.hangout.getLocalParticipantLocale.
   * Example: 'en'
   */
  String getPreferredLocale() => _makeStringCall(["getPreferredLocale"]);

  /**
   * Gets the starting data for the current active app.
   * This is the data passed in by the gd URL parameter.
   * Returns null if no start data has been specified.
   */
  String getStartData() => _makeStringCall(["getStartData"]);

  /// Gets the [Participant] with the given [participantId]. Returns null if no participant exists with the given ID.
  Participant getParticipantById(String participantId) {
    var data = _makeProxyCall(["getParticipantById"], [participantId]);
    var participant = null;
    if (data != null) participant = new Participant._internal(data);
    return participant;
  }

  /// Gets the local [Participant].
  Participant getLocalParticipant() {
    var data = _makeProxyCall(["getLocalParticipant"]);
    var participant = null;
    if (data != null) participant = new Participant._internal(data);
    return participant;
  }

  /**
   * Gets the ID of the local participant. A user is assigned a new ID each time they join a hangout.
   * Example: 'hangout65A4C551_ephemeral.id.google.com^354e9d1ed0'
   */
  String getLocalParticipantId() => _makeStringCall(["getLocalParticipantId"]);

  /**
   * Gets the participants in the hangout. Note that the list of participants reflects the current state on the hangouts server.
   * There can be a small window of time where the local participant is not in the returned array.
   */
  List<Participant> getParticipants() {
    var data = _makeProxyCall(["getParticipants"]);
    var participants = new List<Participant>();
    for (var i = 0; i < data.length; i++) {
      var proxy = data[i];
      if (proxy != null) participants.add(new Participant._internal(proxy));
    }
    return participants;
  }

  /// Returns the current hangout topic, or an empty string if a topic was not specified.
  String getTopic() => _makeStringCall(["getTopic"]);

  /**
   * Returns true if the hangout is not open to minors, false if there are no age restrictions.
   */
  bool hasAgeRestriction() => _makeBoolCall(["hasAgeRestriction"]);

  /// Sets the app as not visible in the main hangout window. The app will continue to run while it is hidden.
  void hideApp() => _makeVoidCall(["hideApp"]);

  /**
   * Returns true if the gapi.hangout API is initialized; false otherwise.
   * Before the API is initialized, data values might have unexpected values.
   */
  bool isApiReady() => _makeBoolCall(["isApiReady"]);

  /// Returns true if the app is visible in the main hangout window, false otherwise.
  bool isAppVisible() => _makeBoolCall(["isAppVisible"]);

  /// Returns true if the hangout is open to the public, false otherwise.
  bool isPublic() => _makeBoolCall(["isPublic"]);

  /**
   * Sets whether an application should start automatically at the beginning of Hangouts.
   * This should only be set by a user action, such as a checkbox in a settings dialog box,
   * rather than be done automatically. The user will be notified and given a chance to cancel
   * when an app sets itself to autoload.
   */
  void setWillAutoLoad(bool autoLoad) => _makeVoidCall(["setWillAutoLoad"], [autoLoad]);

  /**
   * Returns whether this application was started automatically at the beginning of the Hangout.
   * If the application was closed and re-opened, this will return false.
   */
  bool wasAutoLoaded() => _makeBoolCall(["wasAutoLoaded"]);

  /// Returns whether this application will start automatically at the beginning of a Hangout.
  bool willAutoLoad() => _makeBoolCall(["willAutoLoad"]);
}


/// A Participant instance represents a person who has joined a Google hangout.
class Participant {

  /**
   * A string uniquely identifying this participant in the hangout.
   * It is not suitable for display to the user. Each time a user joins a hangout, they are assigned a new participant ID.
   * This ID is used to identify a participant throughout the API.
   * Example: 'hangout65A4C551_ephemeral.id.google.com^354e9d1ed0'
   */
  String id;

  /// The index of the participant on the filmstrip, 0-based. Can be null.
  int displayIndex;

  /// True if the participant has a microphone installed.
  bool hasMicrophone;

  /// True if the participant has a video camera installed.
  bool hasCamera;

  /// True if the participant has this app enabled and running in this hangout.
  bool hasAppEnabled;

  /// True if the participant is the broadcaster. The broadcaster is the owner of the hangout, but only if it is a Hangout On Air.
  bool isBroadcaster;

  /// True if the participant will appear in the Hangout On Air broadcast, if this is a Hangout On Air.
  bool isInBroadcast;

  /// The locale of the participant. Null if the locale is not known. Locale is always unknown for mobile participants. Example: 'en'
  String locale;

  /// The representation of the participant's Google+ person.
  ParticipantPerson person;

  Participant._internal(JsObject data) {
    id = data["id"];
    hasMicrophone = data["hasMicrophone"];
    hasCamera = data["hasCamera"];
    hasAppEnabled  = data["hasAppEnabled"];
    isBroadcaster = data["isBroadcaster"];
    isInBroadcast = data["isInBroadcast"];
    locale = data["locale"];
    if (data["person"] != null) person = new ParticipantPerson._internal(data["person"]);
  }
}

/// The representation of the participant's Google+ person.
class ParticipantPerson {

  /**
   * The Google+ ID uniquely identifying this participant.
   * The Google+ ID will never change for a participant.
   * This ID is not suitable for display to the user. Example: '123456789727111132824'
   */
  String id;

  /// The name of the participant, suitable for display to the user.
  String displayName;

  /// The representation of the participant's profile photo.
  ParticipantPersonImage image;

  ParticipantPerson._internal(JsObject data) {
    id = data["id"];
    displayName = data["displayName"];
    if (data["image"] != null) image = new ParticipantPersonImage._internal(data["image"]);
  }
}

/// The representation of the participant's profile photo.
class ParticipantPersonImage {

  /**
   * The URL to an image suitable for representing the participant.
   * If the participant has not specified a custom image, then a generic image is provided.
   */
  String url;

  ParticipantPersonImage._internal(JsObject data) {
    url = data["url"];
  }
}

// ****************************
// Events
// ****************************

class ApiReadyHandler extends OnceEventHandler {

  ApiReadyHandler._internal() : super._internal(["onApiReady"], HangoutEvent.API_READY_EVENT);

  void add(void callback(ApiReadyEvent event)) {
    super.add(callback);
  }

  void remove(void callback(ApiReadyEvent event)) {
    super.remove(callback);
  }
}

/// Contains information about the API becoming ready.
class ApiReadyEvent extends HangoutEvent {

  /// Indicates whether the API is ready.
  bool isApiReady;

  ApiReadyEvent._internal(JsObject data) : super._internal() {
    if (data["isApiReady"] != null) {
      isApiReady = data["isApiReady"];
    } else {
      throw new HangoutAPIException("Invalid return value in onApiReady callback");
    }
  }
}

class AppVisibleHandler extends ManyEventHandler {

  AppVisibleHandler._internal() : super._internal(["onAppVisible"], HangoutEvent.APP_VISIBLE_EVENT);

  void add(void callback(AppVisibleEvent event)) {
    super.add(callback);
  }

  void remove(void callback(AppVisibleEvent event)) {
    super.remove(callback);
  }
}

/// Contains information about an an app becoming visible in a hangout.
class AppVisibleEvent extends HangoutEvent {

  /// Indicates whether the app is visible.
  bool isAppVisible;

  AppVisibleEvent._internal(JsObject data) : super._internal() {
    if (data["isAppVisible"] != null) {
      isAppVisible = data["isAppVisible"];
    } else {
      throw new HangoutAPIException("Invalid return value in onAppVisible callback");
    }
  }
}

class EnabledParticipantsChangedHandler extends ManyEventHandler {

  EnabledParticipantsChangedHandler._internal() : super._internal(["onEnabledParticipantsChanged"], HangoutEvent.ENABLED_PARTICIPANTS_CHANGED_EVENT);

  void add(void callback(EnabledParticipantsChangedEvent event)) {
    super.add(callback);
  }

  void remove(void callback(EnabledParticipantsChangedEvent event)) {
    super.remove(callback);
  }
}

/// Contains information about participants running this app.
class EnabledParticipantsChangedEvent extends HangoutEvent {

  /// List of all participants who are running this app.
  List<Participant> enabledParticipants;

  EnabledParticipantsChangedEvent._internal(JsObject data) : super._internal() {
    if (data["enabledParticipants"] != null) {
      enabledParticipants = new List();
      for (var i = 0; i < data["enabledParticipants"].length; i++) {
        enabledParticipants.add(new Participant._internal(data["enabledParticipants"][i]));
      }
    } else {
      throw new HangoutAPIException("Invalid return value in onEnabledParticipantsChanged callback");
    }
  }
}

class ParticipantsAddedHandler extends ManyEventHandler {

  ParticipantsAddedHandler._internal() : super._internal(["onParticipantsAdded"], HangoutEvent.PARTICIPANTS_ADDED_EVENT);

  void add(void callback(ParticipantsAddedEvent event)) {
    super.add(callback);
  }

  void remove(void callback(ParticipantsAddedEvent event)) {
    super.remove(callback);
  }
}

/// Contains information about participants who have joined the event.
class ParticipantsAddedEvent extends HangoutEvent {

  /// List of the newly added participants.
  List<Participant> addedParticipants;

  ParticipantsAddedEvent._internal(JsObject data) : super._internal() {
    if (data["addedParticipants"] != null) {
      addedParticipants = new List();
      for (var i = 0; i < data["addedParticipants"].length; i++) {
        addedParticipants.add(new Participant._internal(data["addedParticipants"][i]));
      }
    } else {
      throw new HangoutAPIException("Invalid return value in onParticipantsAdded callback");
    }
  }
}

class ParticipantsChangedHandler extends ManyEventHandler {

  ParticipantsChangedHandler._internal() : super._internal(["onParticipantsChanged"], HangoutEvent.PARTICIPANTS_CHANGED_EVENT);

  void add(void callback(ParticipantsChangedEvent event)) {
    super.add(callback);
  }

  void remove(void callback(ParticipantsChangedEvent event)) {
    super.remove(callback);
  }
}

/// Contains information about a change of participants joining or leaving the hangout.
class ParticipantsChangedEvent extends HangoutEvent {

  /// List of the participants currently in the hangout.
  List<Participant> participants;

  ParticipantsChangedEvent._internal(JsObject data) : super._internal() {
    if (data["participants"] != null) {
      participants = new List();
      for (var i = 0; i < data["participants"].length; i++) {
        participants.add(new Participant._internal(data["participants"][i]));
      }
    } else {
      throw new HangoutAPIException("Invalid return value in onParticipantsChanged callback");
    }
  }
}

class ParticipantsDisabledHandler extends ManyEventHandler {

  ParticipantsDisabledHandler._internal() : super._internal(["onParticipantsDisabled"], HangoutEvent.PARTICIPANTS_DISABLED_EVENT);

  void add(void callback(ParticipantsDisabledEvent event)) {
    super.add(callback);
  }

  void remove(void callback(ParticipantsDisabledEvent event)) {
    super.remove(callback);
  }
}

/// Contains information about participants who have stopped running this app.
class ParticipantsDisabledEvent extends HangoutEvent {

  /// List of the participants that stopped running this app.
  List<Participant> disabledParticipants;

  ParticipantsDisabledEvent._internal(JsObject data) : super._internal() {
    if (data["disabledParticipants"] != null) {
      disabledParticipants = new List();
      for (var i = 0; i < data["disabledParticipants"].length; i++) {
        disabledParticipants.add(new Participant._internal(data["disabledParticipants"][i]));
      }
    } else {
      throw new HangoutAPIException("Invalid return value in onParticipantsDisabled callback");
    }
  }
}

class ParticipantsEnabledHandler extends ManyEventHandler {

  ParticipantsEnabledHandler._internal() : super._internal(["onParticipantsEnabled"], HangoutEvent.PARTICIPANTS_ENABLED_EVENT);

  void add(void callback(ParticipantsEnabledEvent event)) {
    super.add(callback);
  }

  void remove(void callback(ParticipantsEnabledEvent event)) {
    super.remove(callback);
  }
}

/// Contains information about participants who have started running this app.
class ParticipantsEnabledEvent extends HangoutEvent {

  /// List of the participants who started running this app.
  List<Participant> enabledParticipants;

  ParticipantsEnabledEvent._internal(JsObject data) : super._internal() {
    if (data["enabledParticipants"] != null) {
      enabledParticipants = new List();
      for (var i = 0; i < data["enabledParticipants"].length; i++) {
        enabledParticipants.add(new Participant._internal(data["enabledParticipants"][i]));
      }
    } else {
      throw new HangoutAPIException("Invalid return value in onParticipantsEnabled callback");
    }
  }
}

class ParticipantsRemovedHandler extends ManyEventHandler {

  ParticipantsRemovedHandler._internal() : super._internal(["onParticipantsRemoved"], HangoutEvent.PARTICIPANTS_REMOVED_EVENT);

  void add(void callback(ParticipantsRemovedEvent event)) {
    super.add(callback);
  }

  void remove(void callback(ParticipantsRemovedEvent event)) {
    super.remove(callback);
  }
}

/// Contains information about participants who have left the hangout.
class ParticipantsRemovedEvent extends HangoutEvent {

  /// List of the participants who have left the hangout.
  List<Participant> removedParticipants;

  ParticipantsRemovedEvent._internal(JsObject data) : super._internal() {
    if (data["removedParticipants"] != null) {
      removedParticipants = new List();
      for (var i = 0; i < data["removedParticipants"].length; i++) {
        removedParticipants.add(new Participant._internal(data["removedParticipants"][i]));
      }
    } else {
      throw new HangoutAPIException("Invalid return value in onParticipantsRemoved callback");
    }
  }
}

class PreferredLocaleChangedHandler extends ManyEventHandler {

  PreferredLocaleChangedHandler._internal() : super._internal(["onPreferredLocaleChanged"], HangoutEvent.PREFERRED_LOCALE_CHANGED_EVENT);

  void add(void callback(PreferredLocaleChangedEvent event)) {
    super.add(callback);
  }

  void remove(void callback(PreferredLocaleChangedEvent event)) {
    super.remove(callback);
  }
}

/// Contains information about a change to the hangout's preferred locale.
class PreferredLocaleChangedEvent extends HangoutEvent {

  /// Indicates the new preferred locale for the hangout.
  String preferredLocale;

  PreferredLocaleChangedEvent._internal(JsObject data) : super._internal() {
    if (data["preferredLocale"] != null) {
      preferredLocale = data["preferredLocale"];
    } else {
      throw new HangoutAPIException("Invalid return value in onPreferredLocaleChanged callback");
    }
  }
}

class PublicChangedHandler extends ManyEventHandler {

  PublicChangedHandler._internal() : super._internal(["onPublicChanged"], HangoutEvent.PUBLIC_CHANGED_EVENT);

  void add(void callback(PublicChangedEvent event)) {
    super.add(callback);
  }

  void remove(void callback(PublicChangedEvent event)) {
    super.remove(callback);
  }
}

/// Contains information about the hangout becoming open to the public.
class PublicChangedEvent extends HangoutEvent {

  /// Indicates whether the hangout is open to the public.
  bool isPublic;

  PublicChangedEvent._internal(JsObject data) : super._internal() {
    if (data["isPublic"] != null) {
      isPublic = data["isPublic"];
    } else {
      throw new HangoutAPIException("Invalid return value in onPublicChanged callback");
    }
  }
}

class TopicChangedHandler extends ManyEventHandler {

  TopicChangedHandler._internal() : super._internal(["onTopicChanged"], HangoutEvent.TOPIC_CHANGED_EVENT);

  void add(void callback(TopicChangedEvent event)) {
    super.add(callback);
  }

  void remove(void callback(TopicChangedEvent event)) {
    super.remove(callback);
  }
}

/// Contains information about the changing of a hangout topic.
class TopicChangedEvent extends HangoutEvent {
  String topic;

  /// The new hangout topic.
  TopicChangedEvent._internal(JsObject data) : super._internal() {
    if (data["topic"] != null) {
      topic = data["topic"];
    } else {
      throw new HangoutAPIException("Invalid return value in onTopicChanged callback");
    }
  }
}
