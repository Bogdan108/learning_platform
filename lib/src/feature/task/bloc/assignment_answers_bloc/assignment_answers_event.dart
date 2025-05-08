import 'package:freezed_annotation/freezed_annotation.dart';
part 'assignment_answers_event.freezed.dart';

@freezed
sealed class AssignmentAnswersEvent with _$AssignmentAnswersEvent {
  const factory AssignmentAnswersEvent.fetch({required String courseId}) =
      AssignmentAnswersEvent$FetchAnswers;
}
