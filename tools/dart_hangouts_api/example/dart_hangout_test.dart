import "dart:html";
import "dart:convert" show JSON;
import "package:hangouts_api/hangouts_api.dart";
import 'package:googleapis/plus/v1.dart';
import 'package:googleapis_auth/auth.dart';
import "package:hangouts_api/hangouts_auth.dart";

Hangout hapi;
var outputDiv;
PlusApi plus;

void output(str, [bool replace = false]) {
  if (replace) outputDiv.text = "";
  outputDiv.appendHtml("$str<br><br>");
}

void authTest() {
  plus.people.get('me').then((p) {
    output(p.displayName);
    output(p.aboutMe);
  });
}

void tests() {

  hapi.av.onCameraMute.add((CameraMuteEvent e) {
    output(e.isCameraMute);
  });

  hapi.data.onStateChanged.add((StateChangedEvent e) {
    output(JSON.encode(e.addedKeys), true);
    output(JSON.encode(e.removedKeys));
    output(JSON.encode(e.metadata));
    output(JSON.encode(e.state));
  });

  hapi.onParticipantsChanged.add((ParticipantsChangedEvent e) {
    output("", true);
    e.participants.forEach((p) {
      output(p.person.displayName);
    });
  });

  var participants = hapi.getParticipants();
  participants.forEach((p) {
    output(p.person.displayName);
  });

  querySelector("#button1").onClick.listen((event) {
    hapi.data.submitDelta({"lastUpdate": hapi.getLocalParticipant().person.displayName}, []);
  });

  querySelector("#button2").onClick.listen((event) {
    hapi.layout.getVideoCanvas().setPosition(200, 200);
    hapi.layout.getVideoCanvas().setVisible(!hapi.layout.getVideoCanvas().isVisible());
  });

  querySelector("#button3").onClick.listen((event) {
    if (plus == null) {
      createHangoutAuthFlow([]).then((HangoutOAuth2Flow flow) {
        flow.clientViaUserConsent().then((AuthClient client) {
          flow.close();
          plus = new PlusApi(client);
          authTest();
        });
      });
    } else {
      authTest();
    }
  });

  querySelector("#button4").onClick.listen((event) {
    output("No function assigned");
  });

  querySelector("#button5").onClick.listen((event) {
    output("No function assigned");
  });
}

void main() {
  hapi = new Hangout();
  outputDiv = querySelector("#text");
  outputDiv.text = "";

  hapi.onApiReady.add((ApiReadyEvent event) {
    if (event.isApiReady) {
      tests();
    }
  });
}



