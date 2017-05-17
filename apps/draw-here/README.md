# Draw Here

### Description

There are already several applications out there that allow collaboratively working on a drawing inside of Hangout. The problem is that those drawings will only be visible to people inside of the hangout who are using the application. The purpose of Draw Here is different. It allows you to draw directly on your video canvas, which will be visible to all participants in the hangout without them having to install the application, and it will also be visible in the YouTube broadcast if you are doing an HOA.

See http://www.allmyplus.com/drawhere/ for more information and to test this Hangout application.

### Installation

  * Edit drawhere.xml and replace all occurences of `%YOUR_PATH%` to where you plan to upload the files.

  * Upload all the files to `%YOUR_PATH%`

  * Please note that the files need to be publicly accessible.

  * Go to https://code.google.com/apis/console/ and create a new project.

  * Activate the "Google+ Hangouts API" in Services.

  * Go to "Hangouts" and put the full URL to `%YOUR_PATH%/drawhere.xml` as Application URL

  * Save and you are ready to "Enter a hangout!" :)

### Licenses

```
Copyright 2013 Gerwin Sturm, FoldedSoft e.U. / foldedsoft.at, scarygami.net/+

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
```

Included is [jscolor](http://jscolor.com), a JavaScript Color Picker by [Jan Odvarko](http://odvarko.cz) licensed under [GNU Lesser General Public License](http://www.gnu.org/copyleft/lesser.html)
