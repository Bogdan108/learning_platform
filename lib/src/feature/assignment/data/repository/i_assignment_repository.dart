import 'package:learning_platform/src/feature/assignment/model/assignment.dart';
import 'package:learning_platform/src/feature/assignment/model/assignment_answers.dart';
import 'package:learning_platform/src/feature/assignment/model/assignment_courses.dart';
import 'package:learning_platform/src/feature/assignment/model/assignment_request.dart';

abstract interface class IAssignmentRepository {
  Future<List<Assignment>> fetchCourseAssignments(
    String courseId,
  );

  Future<String> createAssignment(
    String courseId,
    AssignmentRequest request,
  );

  Future<void> editAssignment(
    String assignmentId,
    AssignmentRequest request,
  );

  Future<void> deleteAssignment(
    String assignmentId,
  );

  Future<List<AssignmentCourses>> fetchAssignments();

  Future<List<AssignmentAnswers>> getAnswersByCourse(
    String courseId,
  );
}
