# MonkeyInject

A dependency injection framework for ConnectIQ Applications

Bind Classes to interfaces, declare your dependencies, and let MonkeyInject
handle building.

# Usage

## Modules

`Modules` are where you bind your interfaces to concrete classes. Create your
own Module class and extend the `MonkeyInject.Module` that is included in the
library.

Modules `bind` interfaces, described by symbols to ClassDefs.

```mc
class ConcreteWriteable {
  function write(){
    // Do some work.
  }
}

class MyModule extends MonkeyInject.Module {
  function initialize() {
    Module.initialize();

    bind(:Writeable)          // Bind the Writeable Interface
      .to(ConcreteWriteable); // To the ConcreteWriteable class
  }
}
```

Bindings support different scopes, to determine when a new instance of the
concreate class will be created. Read about Bindings in the Wiki (todo).

## Kernel

The entry point for the library is the `Kernel` object. Instantiate the kernel,
load modules, and call `build()`. The framework will then handle building all of
the appropriate dependencies and will return a fully initialized implementation
of the interface requested.

```mc
class MyApp extends Application.App {
  private var _writeable;
  private var _kernel;

  function initialize() {
    _kernel = new MonkeyInject.Kernel();
    _kernel.load(new MyModule());

    _writeable = _kernel.build(:Writeable);
  }
}
```
