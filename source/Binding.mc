//! Binding.mc
//!
//! Copyright Greg Caufield 2020

using Toybox.System;

module MonkeyInject {
module Internal {

//!
//!
//!
(:background)
class Binding {
  private var resolutionRoot_;
  private var classDef_;
  private var buildingDependencies_;

  function initialize(resolutionRoot, bindingSpec_) {
    resolutionRoot_ = resolutionRoot;
    classDef_ = bindingSpec_.getClassDef();
    buildingDependencies_ = false;
  }

  function build() {
    var configuredDependencies = {};
    var requiredDependencies = [];
    var resolutionRoot = resolutionRoot_.get();

    if( resolutionRoot == null ) {
      // The resolution root that we depend on has been deleted.
      // This is a sign that the Kernel has gone out of scope.
      throw new InjectionException(
          "Resolution Root out of scope");
    }

    if(buildingDependencies_) {
      // A recursive call throw an exception
      throw new InjectionException(
          "Circular dependency detected");
    }

    // Convention over configuration. Classes built using this framework are
    // expected to provide a "static" function that can be called to retrieve
    // their dependencies.
    if( classDef_ has :getDependencies) {
      requiredDependencies = classDef_.getDependencies();
    }

    buildingDependencies_ = true;
    for(var dep = 0; dep < requiredDependencies.size(); dep++) {
      configuredDependencies[requiredDependencies[dep]] = resolutionRoot.build(
        requiredDependencies[dep]);
    }
    buildingDependencies_ = false;

    if(requiredDependencies.size() == 0) {
      return new self.classDef_();
    }
    else {
      return new self.classDef_(configuredDependencies);
    }
  }
}
}
}
