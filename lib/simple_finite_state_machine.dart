library simple_finite_state_machine;

import 'dart:developer';

abstract class StateTransition<T extends MachineState<T>> {
  void entry(T current) {}
  MachineState? target(T current);
  void exit(MachineState next) {}

  @override
  String toString() {
    return runtimeType.toString();
  }
}

abstract class MachineState<T extends MachineState<T>> {
  List<Type> get transitions;

  @override
  String toString() {
    return runtimeType.toString();
  }
}

class Machine {
  final bool logging;
  Machine(MachineState initialState, {this.logging = false}) {
    _states.add(initialState);
  }

  final List<MachineState> _states = [];
  StateTransition? _lastTransition;

  List<MachineState> get states => List.unmodifiable(_states);
  MachineState get currentState => _states.last;

  execute<K>(
    StateTransition<MachineState> transition,
  ) {
    if (currentState.transitions
        .any((element) => element == transition.runtimeType)) {
      _lastTransition?.exit(currentState);
      _lastTransition = transition;
      transition.entry(currentState);
      final nextState = transition.target(currentState);
      if (nextState != null) {
        if (logging) {
          log('State changed from $currentState to $nextState');
        }
        _states.add(nextState);
      }
    } else {
      if (logging) {
        log("Transition $transition is not available in $currentState State");
      }
    }
  }
}

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

void main(List<String> args) {
  final machine = Machine(Solid());

  machine.execute(Melt());
  machine.execute(Vaporize());
  machine.execute(Condense());
  machine.execute(Freeze());
  machine.execute(Condense());
}
