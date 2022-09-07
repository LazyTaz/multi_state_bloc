library multi_state_bloc;

import 'package:collection/collection.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// MultiStateBloc allows you to easily use different
/// states in one bloc.
/// All registered states are automatically updated
/// using the Bloc's [onChange] method override.
abstract class MultiStateBloc<Event, BaseState> extends Bloc<Event, BaseState> {
  final List<BaseState> _states = [];

  MultiStateBloc(super.initialState);

  @override
  void onChange(Change<BaseState> change) {
    super.onChange(change);

    holdState(() => change.nextState!);
  }

  /// Put the state in memory.
  /// [instantiate] should return a new state or an already existing one.
  ///
  /// If the state is already cached then it is replaced.
  void holdState(BaseState Function() instantiate) {
    var instance = instantiate();
    var reference = _findStateInstance(instance);

    if (reference != null) {
      var index = _states.indexOf(reference);

      _states[index] = instance;
    } else {
      _states.add(instance);
    }
  }

  /// Retrieve the state you want.
  state? states<state extends BaseState>() => _findStateByType<state>();

  state? _findStateByType<state extends BaseState>() => _states.whereType<state>().firstOrNull;

  BaseState? _findStateInstance(BaseState state) =>
      _states.firstWhereOrNull((e) => e.runtimeType == state.runtimeType);
}
