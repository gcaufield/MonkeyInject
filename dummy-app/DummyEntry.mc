using Toybox.Application;
using Toybox.WatchUi;

class DummyEntry extends Application.AppBase {
  function initialize() {
    AppBase.initialize();
  }

  function getInitialView() {
    return [new WatchUi.View()];
  }
}
