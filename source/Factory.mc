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

  function get(intf) {
    var resolutionRoot = resolutionRoot_.get();
    if( resolutionRoot == null ) {
      // The resolution root that we depend on has been deleted.
      // This is a sign that the Kernel has gone out of scope.
      throw new InjectionException(
          "Resolution Root out of scope");
    }

    return resolutionRoot.build(intf);
  }
}
}
}
