import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:learning_platform/src/feature/courses/model/addition.dart';

part 'course_additions_response.freezed.dart';
part 'course_additions_response.g.dart';

@freezed
abstract class CourseAdditionsResponse with _$CourseAdditionsResponse {
  const factory CourseAdditionsResponse({
    required List<Addition> materials,
    required List<Addition> links,
  }) = _CourseAdditionsResponse;

  factory CourseAdditionsResponse.fromJson(Map<String, dynamic> json) =>
      _$CourseAdditionsResponseFromJson(json);
}
