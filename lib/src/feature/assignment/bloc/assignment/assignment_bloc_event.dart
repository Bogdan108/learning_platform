import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:learning_platform/src/feature/assignment/model/assignment_request.dart';

part 'assignment_bloc_event.freezed.dart';

@freezed
sealed class AssignmentBlocEvent with _$AssignmentBlocEvent {
  const factory AssignmentBlocEvent.fetch({
    required String courseId,
  }) = FetchEvent;

  const factory AssignmentBlocEvent.create({
    required String courseId,
    required AssignmentRequest request,
  }) = CreateEvent;

  const factory AssignmentBlocEvent.edit({
    required String assignmentId,
    required String courseId,
    required AssignmentRequest request,
  }) = EditEvent;

  const factory AssignmentBlocEvent.delete({
    required String assignmentId,
    required String courseId,
  }) = DeleteEvent;
}
