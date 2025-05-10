import 'dart:async';

import 'package:dio/dio.dart';
import 'package:learning_platform/src/feature/assignment/data/data_source/i_assignment_data_source.dart';
import 'package:learning_platform/src/feature/assignment/model/assignment.dart';
import 'package:learning_platform/src/feature/assignment/model/assignment_courses.dart';
import 'package:learning_platform/src/feature/assignment/model/assignment_request.dart';
import 'package:learning_platform/src/feature/assignment/model/assignment_status.dart';
import 'package:learning_platform/src/feature/assignment/model/student_assignment.dart';

class AssignmentDataSource implements IAssignmentDataSource {
  static const _delay = Duration(milliseconds: 500);
  final Dio _dio;

  AssignmentDataSource({required Dio dio}) : _dio = dio;

  @override
  Future<List<Assignment>> getCourseAssignments(
    String org,
    String token,
    String courseId,
  ) async =>
      Future.delayed(
        _delay,
        () => [
          Assignment(
            id: 'a1',
            name: 'Первое задание',
            startedAt: DateTime.now().subtract(const Duration(days: 5)),
            endedAt: DateTime.now().add(const Duration(days: 1)),
          ),
          Assignment(
            id: 'a2',
            name: 'Второе задание',
            startedAt: DateTime.now().subtract(const Duration(days: 2)),
            endedAt: DateTime.now().add(const Duration(days: 4)),
          ),
        ],
      );

  @override
  Future<String> createAssignment(
    String org,
    String token,
    String courseId,
    AssignmentRequest request,
  ) =>
      Future.delayed(
        _delay,
        () => 'new_${DateTime.now().millisecondsSinceEpoch}',
      );

  @override
  Future<void> editAssignment(
    String org,
    String token,
    String assignmentId,
    AssignmentRequest request,
  ) =>
      Future.delayed(_delay);

  @override
  Future<void> deleteAssignment(
    String org,
    String token,
    String assignmentId,
  ) =>
      Future.delayed(_delay);

  @override
  Future<List<AssignmentCourses>> getAssignments(
    String org,
    String token,
  ) =>
      Future.delayed(
        _delay,
        () => [
          AssignmentCourses(
            courseId: 'c1',
            courseName: 'Русский язык',
            assignments: [
              StudentAssignment(
                id: 'a1',
                name: 'Лексическое значение слов',
                status: AssignmentStatus.pending,
                startedAt: DateTime.now().subtract(const Duration(days: 10)),
                endedAt: DateTime.now().subtract(const Duration(days: 5)),
              ),
              StudentAssignment(
                id: 'a2',
                name: 'Средства связи предложений',
                status: AssignmentStatus.graded,
                startedAt: DateTime.now().subtract(const Duration(days: 3)),
                endedAt: DateTime.now().add(const Duration(days: 2)),
              ),
            ],
          ),
          AssignmentCourses(
            courseId: 'c2',
            courseName: 'Mатематика',
            assignments: [
              StudentAssignment(
                id: 'a3',
                name: 'Рациональные числа',
                status: AssignmentStatus.inReview,
                startedAt: DateTime.now().subtract(const Duration(days: 7)),
                endedAt: DateTime.now().add(const Duration(days: 1)),
              ),
              StudentAssignment(
                id: 'a4',
                name: 'Неравенства, уравнения',
                status: AssignmentStatus.graded,
                startedAt: DateTime.now().subtract(const Duration(days: 1)),
                endedAt: DateTime.now().add(const Duration(days: 5)),
              ),
            ],
          ),
        ],
      );
}
