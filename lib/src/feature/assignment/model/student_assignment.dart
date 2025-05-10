import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:learning_platform/src/feature/assignment/model/assignment_status.dart';

part 'student_assignment.freezed.dart';
part 'student_assignment.g.dart';

@freezed
abstract class StudentAssignment with _$StudentAssignment {
  const factory StudentAssignment({
    required String id,
    required String name,
    @JsonKey(name: 'started_at') required DateTime startedAt,
    @JsonKey(name: 'assignment_status') required AssignmentStatus status,
    @JsonKey(name: 'ended_at') DateTime? endedAt,
  }) = _StudentAssignment;

  factory StudentAssignment.fromJson(Map<String, dynamic> json) =>
      _$StudentAssignmentFromJson(json);
}
