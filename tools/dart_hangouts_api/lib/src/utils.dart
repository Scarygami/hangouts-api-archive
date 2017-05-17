part of hangouts_api;

class HangoutAPIException implements Exception {
  final String msg;
  const HangoutAPIException([this.msg]);
  String toString() => (msg == null) ? "HangoutAPIException" : "HangoutAPIException: $msg";
}

JsObject _createParamProxy(param) {
  if (param is List) return new JsObject.jsify(param);
  if (param is Map) return new JsObject.jsify(param);
  return param;
}

abstract class ProxyObject {
  JsObject _proxy;

  ProxyObject._internal(JsObject this._proxy);
}

String _makeStringCall(List<String> name, [List params = const []]) {
  String value;
  var ns = context["gapi"]["hangout"];
  name.forEach((s) {
    ns = ns[s];
  });
  switch (params.length) {
    case 0: value = ns.apply([]); break;
    case 1: value = ns.apply([_createParamProxy(params[0])]); break;
    default: value = ns.apply([_createParamProxy(params[0]), _createParamProxy(params[1])]); break;
  }
  return value;
}

num _makeNumCall(List<String> name, [List params = const []]) {
  num value;
  var ns = context["gapi"]["hangout"];
  name.forEach((s) {
    ns = ns[s];
  });
  switch (params.length) {
    case 0: value = ns.apply([]); break;
    case 1: value = ns.apply([_createParamProxy(params[0])]); break;
    default: value = ns.apply([_createParamProxy(params[0]), _createParamProxy(params[1])]); break;
  }
  return value;
}

bool _makeBoolCall(List<String> name, [List params = const []]) {
  bool value;
  var ns = context["gapi"]["hangout"];
  name.forEach((s) {
    ns = ns[s];
  });
  switch (params.length) {
    case 0: value = ns.apply([]); break;
    case 1: value = ns.apply([_createParamProxy(params[0])]); break;
    default: value = ns.apply([_createParamProxy(params[0]), _createParamProxy(params[1])]); break;
  }
  return value;
}

void _makeVoidCall(List<String> name, [List params = const []]) {
  var ns = context["gapi"]["hangout"];
  name.forEach((s) {
    ns = ns[s];
  });
  switch (params.length) {
    case 0: ns.apply([]); break;
    case 1: ns.apply([_createParamProxy(params[0])]); break;
    default: ns.apply([_createParamProxy(params[0]), _createParamProxy(params[1])]); break;
  }
}

JsObject _makeProxyCall(List<String> name, [List params = const []]) {
  JsObject value;
  var ns = context["gapi"]["hangout"];
  name.forEach((s) {
    ns = ns[s];
  });
  switch (params.length) {
    case 0: value = ns.apply([]); break;
    case 1: value = ns.apply([_createParamProxy(params[0])]); break;
    default: value = ns.apply([_createParamProxy(params[0]), _createParamProxy(params[1])]); break;
  }
  return value;
}