import 'package:learning_platform/src/feature/assignment/data/data_source/i_assignment_data_source.dart';
import 'package:learning_platform/src/feature/assignment/data/repository/i_assignment_repository.dart';
import 'package:learning_platform/src/feature/assignment/model/assignment.dart';
import 'package:learning_platform/src/feature/assignment/model/assignment_courses.dart';
import 'package:learning_platform/src/feature/assignment/model/assignment_request.dart';
import 'package:learning_platform/src/feature/authorization/data/storage/i_storage.dart';
import 'package:learning_platform/src/feature/authorization/data/storage/token_storage.dart';

class AssignmentRepository implements IAssignmentRepository {
  final IAssignmentDataSource _dataSource;
  final TokenStorage _tokenStorage;
  final IStorage<String> _orgIdStorage;

  AssignmentRepository({
    required IAssignmentDataSource dataSource,
    required TokenStorage tokenStorage,
    required IStorage<String> orgIdStorage,
  })  : _dataSource = dataSource,
        _tokenStorage = tokenStorage,
        _orgIdStorage = orgIdStorage;

  String get _token => _tokenStorage.load() ?? '';
  String get _org => _orgIdStorage.load() ?? '';

  @override
  Future<List<Assignment>> fetchCourseAssignments(String courseId) =>
      _dataSource.getCourseAssignments(_org, _token, courseId);

  @override
  Future<String> createAssignment(String courseId, AssignmentRequest request) =>
      _dataSource.createAssignment(_org, _token, courseId, request);

  @override
  Future<void> editAssignment(String assignmentId, AssignmentRequest request) =>
      _dataSource.editAssignment(_org, _token, assignmentId, request);

  @override
  Future<void> deleteAssignment(String assignmentId) =>
      _dataSource.deleteAssignment(_org, _token, assignmentId);

  @override
  Future<List<AssignmentCourses>> fetchAssignments() =>
      _dataSource.getAssignments(_org, _token);
}
