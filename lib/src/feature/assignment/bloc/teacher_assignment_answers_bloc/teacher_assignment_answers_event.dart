import 'package:freezed_annotation/freezed_annotation.dart';
part 'teacher_assignment_answers_event.freezed.dart';

@freezed
sealed class TeacherAssignmentAnswersEvent with _$TeacherAssignmentAnswersEvent {
  const factory TeacherAssignmentAnswersEvent.fetch({required String courseId}) =
      TeacherAssignmentAnswersEvent$FetchAnswers;
}
