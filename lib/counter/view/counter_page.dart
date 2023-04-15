// Copyright (c) 2022, Very Good Ventures
// https://verygood.ventures
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:step_counter_app/counter/counter.dart';
import 'package:step_counter_app/counter/cubit/counter_state.dart';
import 'package:step_counter_app/l10n/l10n.dart';

class CounterPage extends StatelessWidget {
  const CounterPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CounterCubit(),
      child: const CounterView(),
    );
  }
}

class CounterView extends StatelessWidget {
  const CounterView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BlocListener<CounterCubit, CounterState>(
      listener: (context, state) {
        if (state.currentCount % 10 == 0 && state.isIncrementing) {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Awesome, another 10 steps!'),
            ),
          );
        }
      },
      child: GestureDetector(
        onTap: () => context.read<CounterCubit>().increment(),
        behavior: HitTestBehavior.opaque,
        child: Scaffold(
          appBar: AppBar(title: Text(l10n.counterAppBarTitle)),
          body: const Center(child: CounterText()),
          floatingActionButton: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              FloatingActionButton(
                onPressed: () => context.read<CounterCubit>().increment(),
                child: const Icon(Icons.add),
              ),
              const SizedBox(height: 8),
              FloatingActionButton(
                onPressed: () => context.read<CounterCubit>().decrement(),
                child: const Icon(Icons.remove),
              ),
            ],
          ),
          bottomNavigationBar: BlocBuilder<CounterCubit, CounterState>(
            builder: (context, state) {
              return ElevatedButton(
                style: ButtonStyle(
                  foregroundColor: MaterialStateProperty.resolveWith<Color?>(
                      (Set<MaterialState> states) {
                    if (states.contains(MaterialState.disabled)) {
                      return Colors.black38;
                    }
                    return null; // Defer to the widget's default.
                  }),
                ),
                onPressed: state.canUndo
                    ? () => context.read<CounterCubit>().undo()
                    : null,
                child: const Text('Undo'),
              );
            },
          ),
        ),
      ),
    );
  }
}

class CounterText extends StatelessWidget {
  const CounterText({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final count =
        context.select((CounterCubit cubit) => cubit.state.currentCount);
    return Text('$count', style: theme.textTheme.headline1);
  }
}
