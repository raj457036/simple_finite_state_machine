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
