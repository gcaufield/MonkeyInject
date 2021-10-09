// Kernel.mc
//
// Copyright Greg Caufield 2020

module MonkeyInject {

//!
//!
//!
(:background)
class Kernel {
  private var bindings_;

  function initialize() {
    bindings_ = {};
  }

  function load(mod) {
    mod.getBindings(self.weak(), bindings_);
  }

  function build(intf) {
    if(bindings_[intf] != null) {
      return bindings_[intf].build();
    }

    throw new InjectionException(
        "No binding for interface: " + intf);
  }
}
}
