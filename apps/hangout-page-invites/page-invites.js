(function (win, doc) {
  var app = doc.getElementById('app');

  app.baseUrl = 'https://hangouts.google.com/hangouts/_';

  app.hangoutAppReady = function () {
    app.baseUrl = win.gapi.hangout.getHangoutUrl();
  };

  app.search = function () {
    if (!!app.query) {
      doc.getElementById('search').go();
    }
  };

  app.checkSearch = function (e) {
    if (e.keyCode === 13) {
      app.search();
    }
  };

  app.isPage = function (type) {
    return (type === 'page');
  };

  app.inviteUrl = function (id, baseUrl) {
    return baseUrl + '?eid=' + id;
  };

  app.shareUrl = function (id, baseUrl) {
    return 'https://plus.google.com/share?url=' +
           encodeURIComponent(app.inviteUrl(id, baseUrl));
  };

}(this, this.document));
