import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:learning_platform/src/feature/course/course_details/model/addition.dart';

part 'course_additions.freezed.dart';
part 'course_additions.g.dart';

@freezed
abstract class CourseAdditions with _$CourseAdditions {
  const factory CourseAdditions({
    required List<Addition> materials,
    required List<Addition> links,
  }) = _CourseAdditions;

  factory CourseAdditions.empty() =>
      const CourseAdditions(links: [], materials: []);

  factory CourseAdditions.fromJson(Map<String, dynamic> json) =>
      _$CourseAdditionsFromJson(json);
}
