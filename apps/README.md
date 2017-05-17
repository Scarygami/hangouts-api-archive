# hangout-apps

Various samples for using different aspects of the [Google+ Hangouts API](https://developers.google.com/+/hangouts/).

Since most of those samples are using the dev channel of the API or aren't really interesting beyond tech-demo
they are not published unless noted otherwise.

To test them out you will have to:

1.  Create a project in the [Google Developers Console](https://console.developers.google.com)
2.  Create credentials for a web application.
3.  Enable the "Google+ API" and "Google+ Hangouts API" in "APIs & Auth" > "APIs"
4.  Go to the Google+ Hangouts API settings (which will take you to the old console)
5.  Paste the XML URL given with each sample below as Application URL.
6.  Choose Extension or Main application as specified for each sample.
7.  Add additional OAuth scopes if specified for a sample.
8.  Give the App a name so you can find it easier later.
9.  Enter a Hangout and run the app from your "Developer" apps.


### [custombackground](https://github.com/Scarygami/hangout-apps/tree/master/apps/custombackground)

This sample uses the [Google Picker](https://developers.google.com/picker/) to let users choose one of their images to be used as background replacement.

[XML URL](https://hangout-apps.appspot.com/custombackground/background.xml)

Hangout app type: Main application

Additional OAuth scopes: https://www.googleapis.com/auth/photos

Also available as published app: https://hangout-apps.appspot.com/custombackground/


### [handtracking](https://github.com/Scarygami/hangout-apps/tree/master/apps/handtracking)

Just showing how to use hand tracking overlays (still in dev channel).

[XML URL](https://hangout-apps.appspot.com/handtracking/handtracking.xml)

Hangout app type: Extension

Video (combined with maxheadroom): https://www.youtube.com/watch?v=RXo_BMI68_I


### [maxheadroom](https://github.com/Scarygami/hangout-apps/tree/master/apps/maxheadroom)

Dynamically updating the background replacement with a "Max Headroom box" rendered in THREE.js

[XML URL](https://hangout-apps.appspot.com/maxheadroom/background.xml)

Hangout app type: Extension

Video: https://www.youtube.com/watch?v=fKV216ZzBWI


### [overlayopacity](https://github.com/Scarygami/hangout-apps/tree/master/apps/overlayopacity)

[XML URL](https://hangout-apps.appspot.com/overlayopacity/opacity.xml)

Hangout app type: Extension

Video: https://plus.google.com/+GerwinSturm/posts/ZsqaFmrPzCq


### [slider](https://github.com/Scarygami/hangout-apps/tree/master/apps/slider)

Uses the [Hangouts Media Effects API](https://developers.google.com/+/hangouts/effects)
to create a sliding puzzle out of the video stream.

[XML URL](https://hangout-apps.appspot.com/slider/slider.xml)

Hangout app type: Extension

Video: https://plus.google.com/+GerwinSturm/posts/dhzdRgVhfk3


### [warholify](https://github.com/Scarygami/hangout-apps/tree/master/apps/warholify)

Uses the [Hangouts Media Effects API](https://developers.google.com/+/hangouts/effects)
to create an Warhol-style effect from your video feed.

[XML URL](https://hangout-apps.appspot.com/warholify/warholify.xml)

Hangout app type: Extension

Video: https://plus.google.com/+GerwinSturm/posts/dhzdRgVhfk3
