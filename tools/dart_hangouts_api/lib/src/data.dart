part of hangouts_api;

/// Provides functions for sharing data (getting and setting state) between participants in a hangout.
class HangoutData {

  MessageReceivedHandler _onMessageReceived;
  StateChangedHandler _onStateChanged;

  /**
   * Handles callbacks to be called when a message is received.
   * The argument to the callback is an object containing the participant ID for the sender and the message.
   */
  MessageReceivedHandler get onMessageReceived => _onMessageReceived;

  /**
   * Handles callbacks to be called when a new version of the shared state object is received from the server.
   * The parameter to the callback is a [StateChangedEvent].
   * Note that the callback will also be called for changes in the shared state
   * which result from submitDelta calls made from this participant's app.
   */
  StateChangedHandler get onStateChanged => _onStateChanged;


  HangoutData._internal() {
    _onMessageReceived = new MessageReceivedHandler._internal();
    _onStateChanged = new StateChangedHandler._internal();
  }

  /// Clears a single key/value pair in the shared state object.
  void clearValue(String key) => _makeVoidCall(["data", "clearValue"], [key]);

  /// Gets the keys in the shared state object, a List of strings.
  List<String> getKeys() {
    var data = _makeProxyCall(["data", "getKeys"]);
    var keys = null;
    if (data != null) {
      keys = JSON.decode(context["JSON"].callMethod("stringify", [data]));
    }
    return keys;
  }

  /// Gets the value for a given key. Returns undefined if the key/value does not exist.
  String getValue(String key) => _makeStringCall(["data", "getValue"], [key]);

  /// Gets the shared state object, a set of name/value pairs.
  Map<String, String> getState() {
    var data = _makeProxyCall(["data", "getState"]);
    var state = null;
    if (data != null) {
      state = JSON.decode(context["JSON"].callMethod("stringify", [data]));
    }
    return state;
  }

  /**
   * Gets the state metadata object, which contains the same key/value data as the
   * shared state object retrieved via getState but augmented with additional information.
   * Each metadata entry includes:
   *  * key: the key being added.
   *  * value: the new value being set.
   *  * timestamp: The server time that the key/value was most recently updated.
   *  * timediff: The difference in time on the server between the current time and the time the key/value was most recently updated.
   */
  Map<String, StateMetadata> getStateMetadata() {
    var data = _makeProxyCall(["data", "getStateMetadata"]);
    var metadata = null;
    if (data != null) {
      var tmp = JSON.decode(context["JSON"].callMethod("stringify", [data]));
      tmp.forEach((key, meta) {
        metadata[key] = new StateMetadata._internalMap(meta);
      });
    }
    return metadata;
  }

  /// Sets a single key value pair.
  void setValue(String key, String value) => _makeVoidCall(["data", "setValue"], [key, value]);

  /**
   * Submits a request to update the value of the shared state object.
   *
   * updates: Key/value pairs to add or overwrite.
   * The value in each key/value pair must be a string.
   *
   * removes: A (possibly empty) array of key names to remove.
   */
  void submitDelta(Map<String, String> updates, List<String> removes) => _makeVoidCall(["data", "submitDelta"], [updates, removes]);

  /**
   * Sends a message to the other app participants.
   * A message is simply a string defined by the app.
   * Messages are not retained or stored, and should have lower latency than objects stored via submitDelta.
   * This is a best-effort delivery system, and messages might be lost,
   * so this method should only be used to send things that can be dropped (e.g. sending mouse coordinates from a user).
   */
  void sendMessage(String message) => _makeVoidCall(["data", "sendMessage"], [message]);
}

// ****************************
// Events
// ****************************

class MessageReceivedHandler extends ManyEventHandler {

  MessageReceivedHandler._internal() : super._internal(["data", "onMessageReceived"], HangoutEvent.MESSAGE_RECEIVED_EVENT);

  void add(void callback(MessageReceivedEvent event)) {
    super.add(callback);
  }

  void remove(void callback(MessageReceivedEvent event)) {
    super.remove(callback);
  }
}

/// Contains information about a message from another participant.
class MessageReceivedEvent extends HangoutEvent {

  /// The ID of the participant that sent the message.
  String senderId;

  /// The message itself.
  String message;

  MessageReceivedEvent._internal(JsObject data) : super._internal() {
    if (data["senderId"] != null && data["message"] != null) {
      senderId = data["senderId"];
      message = data["message"];
    } else {
      throw new HangoutAPIException("Invalid return value in onMessageReceived callback");
    }
  }
}

class StateChangedHandler extends ManyEventHandler {

  StateChangedHandler._internal() : super._internal(["data", "onStateChanged"], HangoutEvent.STATE_CHANGED_EVENT);

  void add(void callback(StateChangedEvent event)) {
    super.add(callback);
  }

  void remove(void callback(StateChangedEvent event)) {
    super.remove(callback);
  }
}

/// Contains information about a change in the shared state.
class StateChangedEvent extends HangoutEvent {

  /// A List containing the newly added entries to the state metadata.
  List<StateMetadata> addedKeys;

  /// List of the keys removed in this update.
  List<String> removedKeys;

  /// The state metadata, also available via getStateMetadata.
  Map<String, StateMetadata> metadata;

  /// The shared state, also available via getState.
  Map<String, String> state;

  StateChangedEvent._internal(JsObject data) : super._internal() {
    if (data["addedKeys"] != null && data["removedKeys"] != null && data["metadata"] != null && data["state"] != null) {
      addedKeys = new List();
      for (var i = 0; i < data["addedKeys"].length; i++) {
        addedKeys.add(new StateMetadata._internalProxy(data["addedKeys"][i]));
      }
      removedKeys = new List();
      for (var i = 0; i < data["removedKeys"].length; i++) {
        removedKeys.add(data["removedKeys"][i]);
      }
      state = JSON.decode(context["JSON"].callMethod("stringify", [data["state"]]));

      metadata = new Map();
      var tmp = JSON.decode(context["JSON"].callMethod("stringify", [data["metadata"]]));
      tmp.forEach((key, meta) {
        metadata[key] = new StateMetadata._internalMap(meta);
      });
    } else {
      throw new HangoutAPIException("Invalid return value in onStateChanged callback");
    }
  }
}

class StateMetadata {

  /// Key of the State object
  String key;

  /// The difference in time on the server between the current time and the time the key/value was most recently updated.
  int timediff;

  /// The server time that the key/value was most recently updated.
  int timestamp;

  /// The value of the State object
  String value;

  StateMetadata._internalMap(Map data) {
   key = data["key"];
   timediff = data["timediff"];
   timestamp = data["timestamp"];
   value = data["value"];
  }

  StateMetadata._internalProxy(JsObject data) {
    if (data["key"] != null) key = data["key"];
    if (data["timediff"] != null) timediff = data["timediff"];
    if (data["timediff"] != null) timediff = data["timediff"];
    if (data["value"] != null) value = data["value"];
  }

  Map toJson() => {"key": key, "timediff": timediff, "timestamp": timestamp, "value": value};

  String toString() => JSON.encode(this.toJson());
}

