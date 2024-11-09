import 'package:equatable/equatable.dart';

class TasksStateParent extends Equatable {
  const TasksStateParent({
    this.tasksData = const [],
    this.error,
  });

  final List<Map<String, dynamic>> tasksData;
  final String? error;

  factory TasksStateParent.initial() {
    return const TasksStateParent();
  }

  TasksStateParent copyWith({
    List<Map<String, dynamic>>? tasksData,
    String? error,
  }) {
    return TasksStateParent(
      tasksData: tasksData ?? this.tasksData,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [tasksData, error];
}
