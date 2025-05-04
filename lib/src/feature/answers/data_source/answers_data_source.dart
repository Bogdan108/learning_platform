// import 'package:dio/dio.dart';
// import 'package:learning_platform/src/feature/answers/data_source/i_answers_data_source.dart';
// import 'package:learning_platform/src/feature/answers/model/assignment_answers.dart';

// class AnswersDataSource implements IAnswersDataSource {
//   final Dio _dio;
//   // ignore: public_member_api_docs
//   AnswersDataSource({required Dio dio}) : _dio = dio;

//   @override
//   Future<List<AssignmentAnswers>> fetchAnswers(
//     String orgId,
//     String token,
//     String courseId,
//   ) async {
//     final resp = await _dio.get<List<dynamic>>(
//       '/assignment/answers',
//       queryParameters: {
//         'organization_id': orgId,
//         'token': token,
//         'course_id': courseId,
//       },
//     );

//     return resp.data
//             ?.map((e) => AssignmentAnswers.fromJson(e as Map<String, dynamic>))
//             .toList() ??
//         [];
//   }
// }

import 'dart:async';

import 'package:dio/dio.dart';
import 'package:learning_platform/src/feature/answers/data_source/i_answers_data_source.dart';
import 'package:learning_platform/src/feature/answers/model/assignment_answers.dart';
import 'package:learning_platform/src/feature/answers/model/student_answer.dart';
import 'package:learning_platform/src/feature/profile/model/user_name.dart';

class AnswersDataSource implements IAnswersDataSource {
  final Dio _dio;
  AnswersDataSource({required Dio dio}) : _dio = dio;

  final List<AssignmentAnswers> _answers = [
    const AssignmentAnswers(
      id: 'a-1',
      name: 'Лексическое значение слов (задание 2)',
      students: [
        StudentAnswer(
          studentId: 'u-101',
          name: UserName(
            firstName: 'Ксения',
            secondName: 'Голубева',
            middleName: 'А',
          ),
          evaluated: true,
        ),
        StudentAnswer(
          studentId: 'u-102',
          name: UserName(
            firstName: 'Адам',
            secondName: 'Бартоломей',
            middleName: 'И',
          ),
          evaluated: false,
        ),
        StudentAnswer(
          studentId: 'u-103',
          name: UserName(
            firstName: 'Татьяна',
            secondName: 'Костюкова',
            middleName: 'П',
          ),
          evaluated: false,
        ),
        StudentAnswer(
          studentId: 'u-104',
          name: UserName(
            firstName: 'Олег',
            secondName: 'Маликов',
            middleName: 'Т',
          ),
          evaluated: true,
        ),
        StudentAnswer(
          studentId: 'u-105',
          name: UserName(
            firstName: 'Эдуард',
            secondName: 'Гафанович',
            middleName: 'М',
          ),
          evaluated: false,
        ),
        StudentAnswer(
          studentId: 'u-106',
          name: UserName(
            firstName: 'Илья',
            secondName: 'Пупков',
            middleName: 'А',
          ),
          evaluated: true,
        ),
      ],
    ),
    const AssignmentAnswers(
      id: 'a-2',
      name: 'Средства связи предложений в тексте (задание 1)',
      students: [
        StudentAnswer(
          studentId: 'u-101',
          name: UserName(
            firstName: 'Ксения',
            secondName: 'Голубева',
            middleName: '',
          ),
          evaluated: true,
        ),
        StudentAnswer(
          studentId: 'u-102',
          name: UserName(
            firstName: 'Адам',
            secondName: 'Бартоломей',
            middleName: 'И',
          ),
          evaluated: true,
        ),
        StudentAnswer(
          studentId: 'u-103',
          name: UserName(
            firstName: 'Татьяна',
            secondName: 'Костюкова',
            middleName: 'П',
          ),
          evaluated: false,
        ),
        StudentAnswer(
          studentId: 'u-104',
          name: UserName(
            firstName: 'Олег',
            secondName: 'Маликов',
            middleName: 'Т',
          ),
          evaluated: false,
        ),
        StudentAnswer(
          studentId: 'u-105',
          name: UserName(
            firstName: 'Эдуард',
            secondName: 'Гафанович',
            middleName: 'М',
          ),
          evaluated: true,
        ),
        StudentAnswer(
          studentId: 'u-106',
          name: UserName(
            firstName: 'Илья',
            secondName: 'Пупков',
            middleName: 'А',
          ),
          evaluated: false,
        ),
      ],
    ),
    const AssignmentAnswers(
      id: 'a-3',
      name: 'Стилистический анализ текста (задание 3)',
      students: [
        StudentAnswer(
          studentId: 'u-101',
          name: UserName(
            firstName: 'Ксения',
            secondName: 'Голубева',
            middleName: 'А',
          ),
          evaluated: false,
        ),
      ],
    ),
  ];

  @override
  Future<List<AssignmentAnswers>> fetchAnswers(
    String orgId,
    String token,
    String courseId,
  ) async =>
      await Future.delayed(const Duration(milliseconds: 450), () => _answers);
}
