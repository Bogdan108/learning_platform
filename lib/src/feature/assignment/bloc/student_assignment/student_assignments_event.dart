import 'package:freezed_annotation/freezed_annotation.dart';

part 'student_assignments_event.freezed.dart';

@freezed
sealed class StudentAssignmentsEvent with _$StudentAssignmentsEvent {
  const factory StudentAssignmentsEvent.fetch() = StudentAssignmentsEvent$Fetch;
}
