<!--
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/guides/libraries/writing-package-pages).

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-library-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/developing-packages).
-->

# A Simple Finite State Machine

## Features

- well, its simple to use

## Getting started

```yaml
# add the dependencies
simple_finite_state_machine:
  git: https://github.com/raj457036/simple_finite_state_machine.git
```

## Usage

![Example of state if water](https://github.com/Tinder/StateMachine/raw/main/example/activity-diagram.png)

credit: https://github.com/Tinder/StateMachine

Below is a simple example based on above diagram

```dart
// states
class Solid extends MachineState<Solid> {
  @override
  get transitions => [Melt];
}

class Liquid extends MachineState<Liquid> {
  @override
  get transitions => [Vaporize, Freeze];
}

class Gas extends MachineState<Gas> {
  @override
  get transitions => [Condense];
}

// transitions
class Melt extends StateTransition<Solid> {
  @override
  MachineState? target(current) {
    return Liquid();
  }
}

class Vaporize extends StateTransition<Liquid> {
  @override
  MachineState? target(current) {
    return Gas();
  }
}

class Condense extends StateTransition<Gas> {
  @override
  MachineState? target(current) {
    return Liquid();
  }
}

class Freeze extends StateTransition<Liquid> {
  @override
  MachineState? target(current) {
    return Solid();
  }
}

// main program
void main(List<String> args) {
  final machine = Machine(Solid(), logging: true);

  machine.execute(Melt());
  machine.execute(Vaporize());
  machine.execute(Condense());
  machine.execute(Freeze());
  // This one will fail
  machine.execute(Condense());
}

```

## Additional information

The example above is from [Tinder State Machine Example](https://github.com/Tinder/StateMachine)
