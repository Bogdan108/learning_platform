import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:learning_platform/src/feature/assignment/model/assignment_request.dart';

part 'assignment_event.freezed.dart';

@freezed
sealed class AssignmentEvent with _$AssignmentEvent {
  const factory AssignmentEvent.fetch({
    required String courseId,
  }) = AssignmentEvent$Fetch;

  const factory AssignmentEvent.create({
    required String courseId,
    required AssignmentRequest request,
  }) = AssignmentEvent$Create;

  const factory AssignmentEvent.edit({
    required String assignmentId,
    required String courseId,
    required AssignmentRequest request,
  }) = AssignmentEvent$Edit;

  const factory AssignmentEvent.delete({
    required String assignmentId,
    required String courseId,
  }) = AssignmentEvent$Delete;
}
