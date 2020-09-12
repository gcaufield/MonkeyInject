//! SingletonBinding.mc
//!
//! Copyright Greg Caufield 2020

module MonkeyInject {
module Internal {

//!
//!
//!
class SingletonBinding extends Binding {
  private var instance_;

  function initialize(resolutionRoot, bindingSpec_) {
    Binding.initialize(resolutionRoot, bindingSpec_);

    instance_ = null;
  }

  function build() {
    if(instance_ == null) {
      instance_ = Binding.build();
    }

    return instance_;
  }
}
}
}
