//! Factory.mc
//!
//! Copyright Greg Caufield 2020

module MonkeyInject {
module Internal {

//!
//!
//!
(:background)
class Factory {
  private var resolutionRoot_;

  function initialize(resolutionRoot) {
    resolutionRoot_ = resolutionRoot;
  }

  function build() {
    return self;
  }

  function get(interface) {
    return resolutionRoot_.build(interface);
  }
}
}
}
