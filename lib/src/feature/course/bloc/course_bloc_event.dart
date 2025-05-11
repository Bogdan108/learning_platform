import 'dart:io';

import 'package:freezed_annotation/freezed_annotation.dart';

part 'course_bloc_event.freezed.dart';

@freezed
sealed class CourseBlocEvent with _$CourseBlocEvent {
  const factory CourseBlocEvent.fetchCourseAdditions({
    required String courseId,
  }) = FetchCourseAdditionEvent;

  const factory CourseBlocEvent.deleteAddition({
    required String courseId,
    required String additionType,
    required String additionId,
  }) = DeleteAdditionEvent;

  const factory CourseBlocEvent.addLinkAddition({
    required String courseId,
    required String link,
  }) = AddLinkAdditionEvent;

  const factory CourseBlocEvent.uploadMaterial({
    required String courseId,
    required File? file,
  }) = UploadMaterialEvent;

  /// Student
  const factory CourseBlocEvent.leaveCourse({
    required String courseId,
  }) = LeaveCourseEvent;
}
