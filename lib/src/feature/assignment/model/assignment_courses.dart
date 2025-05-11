import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:learning_platform/src/feature/assignment/model/assignment.dart';

part 'assignment_courses.freezed.dart';
part 'assignment_courses.g.dart';

@freezed
abstract class AssignmentCourses with _$AssignmentCourses {
  const factory AssignmentCourses({
    @JsonKey(name: 'course_id') required String courseId,
    @JsonKey(name: 'course_name') required String courseName,
    required List<Assignment> assignments,
  }) = _AssignmentCourses;

  factory AssignmentCourses.fromJson(Map<String, dynamic> json) =>
      _$AssignmentCoursesFromJson(json);
}
