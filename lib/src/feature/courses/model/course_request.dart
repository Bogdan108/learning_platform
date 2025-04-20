import 'package:freezed_annotation/freezed_annotation.dart';

part 'course_request.freezed.dart';
part 'course_request.g.dart';

@freezed
abstract class CourseRequest with _$CourseRequest {
  const factory CourseRequest({
    required String name,
    required String description,
  }) = _CourseRequest;

  factory CourseRequest.fromJson(Map<String, dynamic> json) =>
      _$CourseRequestFromJson(json);
}
