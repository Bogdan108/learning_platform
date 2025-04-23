import 'package:dio/dio.dart';
import 'package:learning_platform/src/feature/course/data/data_source/i_course_data_source.dart';
import 'package:learning_platform/src/feature/course/model/addition.dart';
import 'package:learning_platform/src/feature/course/model/course_additions.dart';
import 'package:learning_platform/src/feature/course/model/student.dart';
import 'package:learning_platform/src/feature/profile/model/user.dart';
import 'package:learning_platform/src/feature/profile/model/user_name.dart';
import 'package:learning_platform/src/feature/profile/model/user_role.dart';

// class CourseDataSource implements ICourseDataSource {
//   final Dio _dio;

//   CourseDataSource({required Dio dio}) : _dio = dio;

//   @override
//   Future<CourseAdditions> getCourseAdditions(
//     String organizationId,
//     String token,
//     String courseId,
//   ) async {
//     final response = await _dio.get<Map<String, dynamic>>(
//       '/course/additions',
//       queryParameters: {
//         'organization_id': organizationId,
//         'token': token,
//         'course_id': courseId,
//       },
//     );

//     return CourseAdditions.fromJson(response.data!);
//   }

//   @override
//   Future<void> deleteAddition(
//     String organizationId,
//     String token,
//     String courseId,
//     String additionType,
//     String additionId,
//   ) async {
//     await _dio.delete<Map<String, dynamic>>(
//       '/course/additions',
//       queryParameters: {
//         'organization_id': organizationId,
//         'token': token,
//         'course_id': courseId,
//         'addition_type': additionType,
//         'addition_id': additionId,
//       },
//     );
//   }

//   @override
//   Future<void> addLinkAddition(
//     String organizationId,
//     String token,
//     String courseId,
//     String link,
//   ) async {
//     await _dio.post<Map<String, dynamic>>(
//       '/course/teacher/additions/link',
//       queryParameters: {
//         'organization_id': organizationId,
//         'token': token,
//         'course_id': courseId,
//       },
//       data: {link: link},
//     );
//   }

//   @override
//   Future<List<Student>> getCourseStudents(
//     String organizationId,
//     String token,
//     String courseId,
//   ) async {
//     final response = await _dio.get<List<Map<String, dynamic>>>(
//       '/course/teacher/student-list',
//       queryParameters: {
//         'organization_id': organizationId,
//         'token': token,
//         'course_id': courseId,
//       },
//     );

//     return response.data!.map(Student.fromJson).toList();
//   }
// }

/// Мок реализации источника данных для работы с дополнениями и списком студентов курса
class CourseDataSource implements ICourseDataSource {
  final Dio _dio;
  static const _delay = Duration(milliseconds: 500);

  CourseDataSource({required Dio dio}) : _dio = dio;

  @override
  Future<CourseAdditions> getCourseAdditions(
    String organizationId,
    String token,
    String courseId,
  ) async =>
      Future.delayed(
        _delay,
        () => const CourseAdditions(
          materials: [
            Addition(id: 'm1', name: 'Материал 1: Введение.pdf'),
            Addition(id: 'm2', name: 'Материал 2: Продвинутые темы.pdf'),
          ],
          links: [
            Addition(id: 'l1', name: 'https://docs.example.com/guide'),
            Addition(id: 'l2', name: 'https://video.example.com/lecture'),
          ],
        ),
      );

  @override
  Future<void> deleteAddition(
    String organizationId,
    String token,
    String courseId,
    String additionType,
    String additionId,
  ) =>
      Future.delayed(_delay);

  @override
  Future<void> addLinkAddition(
    String organizationId,
    String token,
    String courseId,
    String link,
  ) =>
      Future.delayed(_delay);

  @override
  Future<List<Student>> getCourseStudents(
    String organizationId,
    String token,
    String courseId,
  ) async =>
      Future.delayed(
        _delay,
        () => [
          const Student(
            id: 's1',
            fullName: User(
              fullName: UserName(
                firstName: 'Иван',
                secondName: 'Иванов',
                middleName: 'Ив.',
              ),
              role: UserRole.student,
              email: 'ivan.ivanov@example.com',
            ),
            email: 'ivan.ivanov@example.com',
          ),
          const Student(
            id: 's2',
            fullName: User(
              fullName: UserName(
                firstName: 'Пётр',
                secondName: 'Петров',
                middleName: 'П.',
              ),
              role: UserRole.student,
              email: 'petr.petrov@example.com',
            ),
            email: 'petr.petrov@example.com',
          ),
        ],
      );
}
