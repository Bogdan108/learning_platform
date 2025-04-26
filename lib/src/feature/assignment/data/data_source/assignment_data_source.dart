import 'dart:async';

import 'package:dio/dio.dart';
import 'package:learning_platform/src/feature/assignment/data/data_source/i_assgnment_data_source.dart';
import 'package:learning_platform/src/feature/assignment/model/assignment.dart';
import 'package:learning_platform/src/feature/assignment/model/assignment_request.dart';

class AssignmentDataSource implements IAssignmentDataSource {
  static const _delay = Duration(milliseconds: 500);
  final Dio _dio;

  AssignmentDataSource({required Dio dio}) : _dio = dio;

  @override
  Future<List<Assignment>> getAssignments(
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
}
