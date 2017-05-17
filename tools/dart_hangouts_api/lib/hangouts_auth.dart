library hangouts_auth;

import 'dart:async';
import 'package:http/http.dart';
import 'package:http/browser_client.dart';
import 'package:googleapis_auth/auth.dart';
import 'package:googleapis_auth/src/http_client_base.dart';
import 'package:googleapis_auth/src/auth_http_utils.dart';
import 'package:googleapis_auth/src/oauth2_flows/implicit.dart';

// Code adapted from https://github.com/dart-lang/googleapis_auth
// Copyright (c) 2014, the Dart project authors
// Published under BSD-style license that can be found in the BSD_LICENSE file.


/// Will create and complete with a [HangoutOAuth2Flow] object.
///
/// This function will perform an implicit browser based oauth2 flow.
///
/// It will load Google's `gapi` library and initialize it. After initialization
/// it will complete with a [HangoutOAuth2Flow] object. The flow object can be
/// used to obtain `AccessCredentials` or an authenticated HTTP client.
///
/// If loading or initializing the `gapi` library results in an error, this
/// future will complete with an error.
///
/// [scopes] has to match the additional scopes that you defined in the dev console.
/// The default hangout scopes will be added automatically.
///
/// If [baseClient] is not given, one will be automatically created. It will be
/// used for making authenticated HTTP requests.
///
/// The user is responsible for closing the returned [HangoutOAuth2Flow] object.
/// Closing the returned [HangoutOAuth2Flow] will not close [baseClient]
/// if one was given.
Future<HangoutOAuth2Flow> createHangoutAuthFlow(
    List<String> scopes, {Client baseClient}) {

  if (scopes == null) { scopes = []; }

  scopes.addAll([
    'https://www.googleapis.com/auth/plus.me',
    'https://www.googleapis.com/auth/hangout.av',
    'https://www.googleapis.com/auth/hangout.participants'
  ]);

  if (baseClient == null) {
    baseClient = new RefCountedClient(new BrowserClient(), initialRefCount: 1);
  } else {
    baseClient = new RefCountedClient(baseClient, initialRefCount: 2);
  }

  var flow = new ImplicitFlow(null, scopes);
  return flow.initialize().catchError((error, stack) {
    baseClient.close();
    return new Future.error(error, stack);
  }).then((_) => new HangoutOAuth2Flow._(flow, baseClient));
}

/// Used for obtaining oauth2 access credentials
class HangoutOAuth2Flow {
  final ImplicitFlow _flow;
  final RefCountedClient _client;

  bool _wasClosed = false;

  /// The HTTP client passed in will be closed if `close` was called and all
  /// generated HTTP clients via [clientViaUserConsent] were closed.
  HangoutOAuth2Flow._(this._flow, this._client);

  /// Obtain oauth2 [AccessCredentials].
  ///
  /// The returned future will complete with `AccessCredentials` if the user
  /// has given the application access to its data. Otherwise the future will
  /// complete with a `UserConsentException`.
  ///
  /// In case another error occurs the returned future will complete with an
  /// `Exception`.
  Future<AccessCredentials> obtainAccessCredentialsViaUserConsent() {
    _ensureOpen();
    return _flow.login(force: false, immediate: true);
  }

  /// Obtains [AccessCredentials] and returns an authenticated HTTP client.
  ///
  /// After obtaining access credentials, this function will return an HTTP
  /// [Client]. HTTP requests made on the returned client will get an
  /// additional `Authorization` header with the `AccessCredentials` obtained.
  ///
  /// In case the `AccessCredentials` expire, it will try to obtain new ones
  /// without user consent.
  ///
  /// See [obtainAccessCredentialsViaUserConsent] for how credentials will be
  /// obtained. Errors from [obtainAccessCredentialsViaUserConsent] will be let
  /// through to the returned `Future` of this function and to the returned
  /// HTTP client (in case of credential refreshes).
  ///
  /// The returned HTTP client will forward errors from lower levels via it's
  /// `Future<Response>` or it's `Response.read()` stream.
  ///
  /// The user is responsible for closing the returned HTTP client.
  Future<AutoRefreshingAuthClient> clientViaUserConsent() {
    return obtainAccessCredentialsViaUserConsent()
        .then(_clientFromCredentials);
  }

  /// Will close this [HangoutOAuth2Flow] object and the HTTP [Client] it is
  /// using.
  ///
  /// The clients obtained via [clientViaUserConsent] will continue to work.
  ///
  /// After this flow object and all obtained clients were closed the underlying
  /// HTTP client will be closed as well.
  ///
  /// After calling this `close` method, calls to [clientViaUserConsent],
  /// [obtainAccessCredentialsViaUserConsent] will fail.
  void close() {
    _ensureOpen();
    _wasClosed = true;
    _client.close();
  }

  void _ensureOpen() {
    if (_wasClosed) {
      throw new StateError('HangoutOAuth2Flow has already been closed.');
    }
  }

  AutoRefreshingAuthClient _clientFromCredentials(AccessCredentials cred) {
    _ensureOpen();
    _client.acquire();
    return new _AutoRefreshingHangoutClient(_client, cred, _flow);
  }
}

class _AutoRefreshingHangoutClient extends AutoRefreshDelegatingClient {
  AccessCredentials credentials;
  ImplicitFlow _flow;
  Client _authClient;

  _AutoRefreshingHangoutClient(Client client, this.credentials, this._flow)
      : super(client) {
    _authClient = authenticatedClient(baseClient, credentials);
  }

  Future<StreamedResponse> send(BaseRequest request) {
    if (!credentials.accessToken.hasExpired) {
      return _authClient.send(request);
    } else {
      return _flow.login(immediate: true).then((newCredentials) {
        credentials = newCredentials;
        notifyAboutNewCredentials(credentials);
        _authClient = authenticatedClient(baseClient, credentials);
        return _authClient.send(request);
      });
    }
  }
}
