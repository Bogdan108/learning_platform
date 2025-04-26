import 'package:learning_platform/src/feature/assignment/model/assignment.dart';
import 'package:learning_platform/src/feature/assignment/model/assignment_request.dart';

abstract interface class IAssignmentRepository {
  Future<List<Assignment>> fetchAssignments(String courseId);
  Future<String> createAssignment(String courseId, AssignmentRequest request);
  Future<void> editAssignment(String assignmentId, AssignmentRequest request);
  Future<void> deleteAssignment(String assignmentId);
}
