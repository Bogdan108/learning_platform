import 'package:freezed_annotation/freezed_annotation.dart';
part 'answers_bloc_event.freezed.dart';

@freezed
sealed class AnswersBlocEvent with _$AnswersBlocEvent {
  const factory AnswersBlocEvent.fetch({required String courseId}) =
      FetchAnswersEvent;
}
