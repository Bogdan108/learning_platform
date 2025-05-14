import 'dart:typed_data';

import 'package:freezed_annotation/freezed_annotation.dart';
part 'course_event.freezed.dart';

@freezed
sealed class CourseEvent with _$CourseEvent {
  const factory CourseEvent.fetchCourseAdditions({
    required String courseId,
  }) = CourseEvent$FetchCourseAddition;

  const factory CourseEvent.deleteAddition({
    required String courseId,
    required String additionType,
    required String additionId,
  }) = CourseEvent$DeleteAddition;

  const factory CourseEvent.addLinkAddition({
    required String courseId,
    required String link,
  }) = CourseEvent$AddLinkAddition;

  const factory CourseEvent.uploadMaterial({
    required String courseId,
    required Uint8List file,
    required String fileName,
  }) = CourseEvent$UploadMaterial;

  /// Student
  const factory CourseEvent.leaveCourse({
    required String courseId,
  }) = CourseEvent$LeaveCourse;
}
