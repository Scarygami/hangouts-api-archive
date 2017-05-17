# dart_hangouts_api

### Description

Wraps all the Google+ Hangout API calls to make it easy to write Hangout Apps in Dart with all the js-interop happening in the background in the library.

Official API documentation: https://developers.google.com/+/hangouts/


### Usage

Create a new Web application in Dart Editor and delete the .html;

Add this dependency to your pubspec.yaml

```
  dependencies:
    hangouts_api: any
```

Create a Gadget xml file similar to this to include your HTML.

```
  <?xml version="1.0" encoding="UTF-8" ?>
  <Module>
    <ModulePrefs title="Dart Hangout Test">
      <Require feature="rpc"/>
      <Require feature="views"/>
      <Require feature="locked-domain"/>
    </ModulePrefs>
    <Content type="html">
      <![CDATA[
  <!DOCTYPE html>
  <html>
    <head>
      <meta charset="utf-8">
      <title>Dart_hangout_test</title>
      <link rel="stylesheet" href="<YOUR_SERVER_PATH>/dart_hangout_test.css">
      <script src="//plus.google.com/hangouts/_/api/v1/hangout.js"></script>
    </head>
    <body>
      <h1>Dart-Hangout-Test</h1>
      <button id="button1">Button 1</button>
      <button id="button2">Button 2</button>
      <button id="button3">Button 3</button>
      <button id="button4">Button 4</button>
      <button id="button5">Button 5</button>
      <div id="container">
        <p id="text"></p>
      </div>
      <script type="application/dart" src="<YOUR_SERVER_PATH>/dart_hangout_test/dart_hangout_test.dart"></script>
      <script src="<YOUR_SERVER_PATH>/dart_hangout_test/packages/browser/dart.js"></script>
      <script src="<YOUR_SERVER_PATH>/dart_hangout_test/packages/browser/interop.js"></script>
    </body>
  </html>
      ]]>
    </Content>
  </Module>
```

Make sure to use a full server path for `<YOUR_SERVER_PATH>` which has to be a publicly available.

In your Dart application import the Hangout API Library:

```
import "package:hangouts_api/hangouts_api.dart";
```

Then you can initialize it and wait for the onAPIReady event:

```
  hapi = new Hangout();
  hapi.onApiReady.add((ApiReadyEvent event) {
    if (event.isApiReady) {
      // you can start using the API now
    }
  });
```

You can then use all of the API calls as documented at https://developers.google.com/+/hangouts/api/

### Using Google APIs

If you want to use Google APIs from within your Hangout application that need authentication
you can use the provided auth methods that work together with the
[`googleapis` libraries](https://pub.dartlang.org/packages/googleapis).

Example:

```
import "package:hangouts_api/hangouts_auth.dart";
import 'package:googleapis/plus/v1.dart'; // include any API(s) you want to use

function login() {
    // add any additional scopes you defined in the dev console here,
    // the default hangout scopes will be added automatically
    var scopes = [];

    createHangoutAuthFlow(scopes).then((flow) {
        flow.clientViaUserConsent().then((client) {
          flow.close();
          var plus = new PlusApi(client);
          plus.people.get('me').then(...);
        });
    });
}
```

This can be called at any point after the `hapi.onApiReady` event.

### Testing

To test your application you will first have to upload it (including the packages) to `<YOUR_SERVER_PATH>`

Then go to [google apis console](https://code.google.com/apis/console/) and create a new Project.

Create a new `Client ID` for web applications in "API Access"

Activate the Google+ Hangouts API in "Services"

In "Hangouts" enter the URL to your XML file in Application URL.

At the bottom of that page you can then "Save" and "Enter a hangout".

(Of course this will only work in Dartium without compiling to js...)

### Disclaimer

Still needs lots of testing, use with care.

### Licenses

```
Copyright (c) 2013-2015 Gerwin Sturm, FoldedSoft e.U. / www.foldedsoft.at

Licensed under the Apache License, Version 2.0 (the "License"); you may not
use this file except in compliance with the License. You may obtain a copy of
the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
License for the specific language governing permissions and limitations under
the License

```
