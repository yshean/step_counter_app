import 'package:equatable/equatable.dart';

class CounterState extends Equatable {
  const CounterState(this.currentCount, this.previousCount);

  bool get isIncrementing => currentCount > (previousCount ?? 0);

  bool get canUndo => previousCount != null && previousCount != currentCount;

  final int currentCount;
  final int? previousCount;

  @override
  List<Object?> get props => [currentCount, previousCount];
}
