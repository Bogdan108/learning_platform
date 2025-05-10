import 'package:learning_platform/src/feature/assignment/model/assignment.dart';
import 'package:learning_platform/src/feature/assignment/model/assignment_courses.dart';
import 'package:learning_platform/src/feature/assignment/model/assignment_request.dart';

abstract interface class IAssignmentDataSource {
  Future<List<Assignment>> getCourseAssignments(
    String organizationId,
    String token,
    String courseId,
  );

  Future<String> createAssignment(
    String organizationId,
    String token,
    String courseId,
    AssignmentRequest request,
  );

  Future<void> editAssignment(
    String organizationId,
    String token,
    String assignmentId,
    AssignmentRequest request,
  );

  Future<void> deleteAssignment(
    String organizationId,
    String token,
    String assignmentId,
  );

  Future<List<AssignmentCourses>> getAssignments(
    String organizationId,
    String token,
  );
}
