// Copyright (c) 2022, Very Good Ventures
// https://verygood.ventures
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:step_counter_app/counter/cubit/counter_state.dart';

class CounterCubit extends Cubit<CounterState> {
  CounterCubit() : super(const CounterState(0, null));

  CounterState? lastState;

  void increment() =>
      emit(CounterState(state.currentCount + 1, state.currentCount));

  void decrement() =>
      emit(CounterState(max(0, state.currentCount - 1), state.currentCount));

  void undo() => emit(
        CounterState(
          state.previousCount ?? 0,
          state.previousCount,
        ),
      );
}
