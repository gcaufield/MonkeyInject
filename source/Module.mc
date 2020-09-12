// Module.mc
//
// Copyright 2020 Greg Caufield
module MonkeyInject {

//!
//!
//!
(:background)
class Module {
  private var interfaces;

  function initialize() {
    interfaces = {};
  }

  function bind(interface) {
    interfaces[interface] = new Internal.BindingSpec(interface);
    return interfaces[interface];
  }

  function getBindings(resolutionRoot, bindings) {
    var keys = interfaces.keys();

    // Copy all of our bindings into the new dictionary
    for(var i = 0; i < keys.size(); i++) {
      var spec = interfaces[keys[i]];

      if(spec.getScope() == Internal.BindingScopeTransient) {
        bindings[keys[i]] = new Internal.Binding(resolutionRoot, spec);
      } else if(spec.getScope() == Internal.BindingScopeSingleton) {
        bindings[keys[i]] = new Internal.SingletonBinding(resolutionRoot, spec);
      } else if(spec.getScope() == Internal.BindingScopeFactory) {
        bindings[keys[i]] = new Internal.Factory(resolutionRoot);
      }
    }
  }
}
}
