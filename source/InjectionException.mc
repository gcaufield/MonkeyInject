//! InjectionException.mc
//!
//! Copyright Greg Caufield 2020

using Toybox.Lang;

module MonkeyInject {
//!
//!
//!
(:background)
class InjectionException extends Lang.Exception {

  //! Initialize a new InectionException
  //!
  //! @param msg Message describing the exception
  function initialize(msg) {
    Exception.initialize();
    self.mMessage = msg;
  }
}
}
