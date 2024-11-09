import 'package:equatable/equatable.dart';
import 'package:graduation_yamen_mobile/presentation/section_of_teacher/task_manger/viewmodel/task_manger_cubit.dart';

class AssignmentState extends Equatable {
  final String level;
  final String department;
  final String courseName;
  final DateTime? taskDate;
  final TaskType taskType;
  final List<String> selectedStudents;
  final String? selectedAssignmentId;
  final bool isLoading ;
  final List<Map<String, dynamic>> submissions;


  const AssignmentState({
    this.level = '',
    this.department = '',
    this.courseName = '',
    this.taskDate,
    this.taskType = TaskType.assignment,
    this.selectedStudents = const [],
    this.selectedAssignmentId,
    this.isLoading = false,
    this.submissions = const [],
  });

  AssignmentState copyWith({
    String? level,
    String? department,
    String? courseName,
    DateTime? taskDate,
    TaskType? taskType,
    List<String>? selectedStudents,
    String? selectedAssignmentId,
    bool? isLoading,
    List<Map<String, dynamic>>? submissions,
  }) {
    return AssignmentState(
      level: level ?? this.level,
      department: department ?? this.department,
      courseName: courseName ?? this.courseName,
      taskDate: taskDate ?? this.taskDate,
      taskType: taskType ?? this.taskType,
      selectedStudents: selectedStudents ?? this.selectedStudents,
      selectedAssignmentId: selectedAssignmentId ?? this.selectedAssignmentId,
      isLoading: isLoading ?? this.isLoading,
      submissions: submissions ?? this.submissions,
    );
  }

  @override
  List<Object?> get props => [
    level,
    department,
    courseName,
    taskDate,
    taskType,
    selectedStudents,
    selectedAssignmentId,
    isLoading,
    submissions,
  ];
}
