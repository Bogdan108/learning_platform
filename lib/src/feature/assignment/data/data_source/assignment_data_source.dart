import 'dart:async';
import 'package:dio/dio.dart';
import 'package:learning_platform/src/feature/assignment/data/data_source/i_assignment_data_source.dart';
import 'package:learning_platform/src/feature/assignment/model/assignment.dart';
import 'package:learning_platform/src/feature/assignment/model/assignment_answers.dart';
import 'package:learning_platform/src/feature/assignment/model/assignment_courses.dart';
import 'package:learning_platform/src/feature/assignment/model/assignment_request.dart';
import 'package:learning_platform/src/feature/assignment/model/assignment_status.dart';
import 'package:learning_platform/src/feature/assignment/model/student_answer.dart';
import 'package:learning_platform/src/feature/profile/model/user_name.dart';

// class AssignmentDataSource implements IAssignmentDataSource {
//   final Dio _dio;
//   AssignmentDataSource({required Dio dio}) : _dio = dio;

//   @override
//   Future<List<Assignment>> getCourseAssignments(
//     String organizationId,
//     String token,
//     String courseId,
//   ) async {
//     final response = await _dio.get<List<dynamic>>(
//       '/assignment/list',
//       queryParameters: {
//         'organization_id': organizationId,
//         'token': token,
//         'course_id': courseId,
//       },
//     );

//     return response.data?.map((e) => Assignment.fromJson(e as Map<String, dynamic>)).toList() ?? [];
//   }

//   @override
//   Future<String> createAssignment(
//     String organizationId,
//     String token,
//     String courseId,
//     AssignmentRequest request,
//   ) async {
//     final response = await _dio.post<Map<String, dynamic>>(
//       '/assignment/teacher',
//       queryParameters: {
//         'organization_id': organizationId,
//         'token': token,
//         'course_id': courseId,
//       },
//       data: request.toJson(),
//     );

//     if (response.data != null && response.data!.containsKey('assignment_id')) {
//       return response.data!['assignment_id'] as String;
//     }
//     throw Exception('Failed to create assignment');
//   }

//   @override
//   Future<void> editAssignment(
//     String organizationId,
//     String token,
//     String assignmentId,
//     AssignmentRequest request,
//   ) async {
//     await _dio.put<void>(
//       '/assignment/teacher',
//       queryParameters: {
//         'organization_id': organizationId,
//         'token': token,
//         'assignment_id': assignmentId,
//       },
//       data: request.toJson(),
//     );
//   }

//   @override
//   Future<void> deleteAssignment(
//     String organizationId,
//     String token,
//     String assignmentId,
//   ) async {
//     await _dio.delete<void>(
//       '/assignment/teacher',
//       queryParameters: {
//         'organization_id': organizationId,
//         'token': token,
//         'assignment_id': assignmentId,
//       },
//     );
//   }

//   @override
//   Future<List<AssignmentAnswers>> fetchAssignmentAnswers(
//       String organizationId, String token, String courseId) async {
//     final response = await _dio.get<List<dynamic>>(
//       '/course/assignments/answers',
//       queryParameters: {
//         'organization_id': organizationId,
//         'token': token,
//         'course_id': courseId,
//       },
//     );

//     return response.data
//             ?.map((item) => AssignmentAnswers.fromJson(item as Map<String, dynamic>))
//             .toList() ??
//         [];
//   }

//   @override
//   Future<List<AssignmentCourses>> getAssignments(String organizationId, String token) async {
//     final response = await _dio.get<List<dynamic>>(
//       '/assignment/courses',
//       queryParameters: {
//         'organization_id': organizationId,
//         'token': token,
//       },
//     );

//     return response.data
//             ?.map((e) => AssignmentCourses.fromJson(e as Map<String, dynamic>))
//             .toList() ??
//         [];
//   }
// }

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
            status: AssignmentStatus.graded,
          ),
          Assignment(
            id: 'a2',
            name: 'Второе задание',
            startedAt: DateTime.now().subtract(const Duration(days: 2)),
            endedAt: DateTime.now().add(const Duration(days: 4)),
            status: AssignmentStatus.pending,
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
              Assignment(
                id: 'a1',
                name: 'Лексическое значение слов',
                status: AssignmentStatus.pending,
                startedAt: DateTime.now().subtract(const Duration(days: 10)),
                endedAt: DateTime.now().subtract(const Duration(days: 5)),
              ),
              Assignment(
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
              Assignment(
                id: 'a3',
                name: 'Рациональные числа',
                status: AssignmentStatus.inReview,
                startedAt: DateTime.now().subtract(const Duration(days: 7)),
                endedAt: DateTime.now().add(const Duration(days: 1)),
              ),
              Assignment(
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

  @override
  Future<List<AssignmentAnswers>> fetchAssignmentAnswers(
    String organizationId,
    String token,
    String courseId,
  ) async =>
      await Future.delayed(const Duration(milliseconds: 450), () => _answers);
}

final List<AssignmentAnswers> _answers = [
  const AssignmentAnswers(
    id: 'a-1',
    name: 'Лексическое значение слов (задание 2)',
    students: [
      StudentAnswer(
        userId: 'u-101',
        name: UserName(
          firstName: 'Ксения',
          secondName: 'Голубева',
          middleName: 'А',
        ),
        isEvaluated: true,
      ),
      StudentAnswer(
        userId: 'u-102',
        name: UserName(
          firstName: 'Адам',
          secondName: 'Бартоломей',
          middleName: 'И',
        ),
        isEvaluated: false,
      ),
      StudentAnswer(
        userId: 'u-103',
        name: UserName(
          firstName: 'Татьяна',
          secondName: 'Костюкова',
          middleName: 'П',
        ),
        isEvaluated: false,
      ),
      StudentAnswer(
        userId: 'u-104',
        name: UserName(
          firstName: 'Олег',
          secondName: 'Маликов',
          middleName: 'Т',
        ),
        isEvaluated: true,
      ),
      StudentAnswer(
        userId: 'u-105',
        name: UserName(
          firstName: 'Эдуард',
          secondName: 'Гафанович',
          middleName: 'М',
        ),
        isEvaluated: false,
      ),
      StudentAnswer(
        userId: 'u-106',
        name: UserName(
          firstName: 'Илья',
          secondName: 'Пупков',
          middleName: 'А',
        ),
        isEvaluated: true,
      ),
    ],
  ),
  const AssignmentAnswers(
    id: 'a-2',
    name: 'Средства связи предложений в тексте (задание 1)',
    students: [
      StudentAnswer(
        userId: 'u-101',
        name: UserName(
          firstName: 'Ксения',
          secondName: 'Голубева',
          middleName: '',
        ),
        isEvaluated: true,
      ),
      StudentAnswer(
        userId: 'u-102',
        name: UserName(
          firstName: 'Адам',
          secondName: 'Бартоломей',
          middleName: 'И',
        ),
        isEvaluated: true,
      ),
      StudentAnswer(
        userId: 'u-103',
        name: UserName(
          firstName: 'Татьяна',
          secondName: 'Костюкова',
          middleName: 'П',
        ),
        isEvaluated: false,
      ),
      StudentAnswer(
        userId: 'u-104',
        name: UserName(
          firstName: 'Олег',
          secondName: 'Маликов',
          middleName: 'Т',
        ),
        isEvaluated: false,
      ),
      StudentAnswer(
        userId: 'u-105',
        name: UserName(
          firstName: 'Эдуард',
          secondName: 'Гафанович',
          middleName: 'М',
        ),
        isEvaluated: true,
      ),
      StudentAnswer(
        userId: 'u-106',
        name: UserName(
          firstName: 'Илья',
          secondName: 'Пупков',
          middleName: 'А',
        ),
        isEvaluated: false,
      ),
    ],
  ),
  const AssignmentAnswers(
    id: 'a-3',
    name: 'Стилистический анализ текста (задание 3)',
    students: [
      StudentAnswer(
        userId: 'u-101',
        name: UserName(
          firstName: 'Ксения',
          secondName: 'Голубева',
          middleName: 'А',
        ),
        isEvaluated: false,
      ),
    ],
  ),
];
