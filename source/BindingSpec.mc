// Binding.mc
//
// Copyright Greg Caufield 2020

module MonkeyInject {
module Internal {
enum {
  BindingScopeTransient,
  BindingScopeSingleton,
  BindingScopeFactory
}

//!
//!
//!
(:background)
class BindingSpec {
  private var interface_;
  private var classDef_;
  private var scope_;

  function initialize(intf) {
    interface_ = intf;
    classDef_ = null;
    scope_ = BindingScopeTransient;
  }

  function to(classDef) {
    classDef_ = classDef;
    return self;
  }

  function toFactory() {
    scope_= BindingScopeFactory;
    return self;
  }

  function inSingletonScope() {
    scope_ = BindingScopeSingleton;
    return self;
  }

  function getClassDef() {
    if(classDef_ != null) {
      return classDef_;
    }

    throw new InjectionException(
        "Interface not bound to class def");
  }

  function getScope() {
    return scope_;
  }
}
}
}
