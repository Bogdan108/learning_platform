import 'package:freezed_annotation/freezed_annotation.dart';
part 'answers_info_bloc_event.freezed.dart';

@freezed
sealed class AnswersInfoBlocEvent with _$AnswersInfoBlocEvent {
  const factory AnswersInfoBlocEvent.fetch({required String courseId}) =
      FetchAnswersEvent;
}
