import 'package:freezed_annotation/freezed_annotation.dart';

part 'course_bloc_event.freezed.dart';

@freezed
sealed class CourseBlocEvent with _$CourseBlocEvent {
  const factory CourseBlocEvent.fetchCourseAdditions({
    required String organizationId,
    required String token,
    required String courseId,
  }) = FetchCourseAdditionEvent;

  const factory CourseBlocEvent.deleteAddition({
    required String organizationId,
    required String token,
    required String courseId,
    required String additionType,
    required String additionId,
  }) = DeleteAdditionEvent;

  const factory CourseBlocEvent.addLinkAddition({
    required String organizationId,
    required String token,
    required String courseId,
    required String link,
  }) = AddLinkAdditionEvent;
}
