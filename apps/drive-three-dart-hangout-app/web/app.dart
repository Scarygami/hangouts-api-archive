import "dart:html";
import "dart:async";
import "package:hangouts_api/hangouts_api.dart";
import "package:google_oauth2_client/google_oauth2_browser.dart";
import "package:google_drive_v2_api/drive_v2_api_browser.dart" as drivelib;
import "package:google_oauth2_v2_api/oauth2_v2_api_browser.dart" as oauthlib;
import "src/HangoutOAuth2.dart";

HangoutOAuth2 auth;

void initialize() {
  auth = new HangoutOAuth2([drivelib.Drive.DRIVE_FILE_SCOPE, oauthlib.Oauth2.USERINFO_EMAIL_SCOPE]);
  auth.login().then((t) {
    print(t);
  });
}

void main() {
  var hapi = new Hangout();
  hapi.onApiReady.add((e) {
    if (e.isApiReady) initialize();
  });
}