// import 'dart:io';
// import 'package:dio/dio.dart';
// import 'package:learning_platform/src/feature/task/data/data_source/i_tasks_data_source.dart';
// import 'package:learning_platform/src/feature/task/model/task.dart';
// import 'package:learning_platform/src/feature/task/model/task_request.dart';

// class TasksDataSource implements ITasksDataSource {
//   final Dio _dio;
//   TasksDataSource({required Dio dio}) : _dio = dio;

//   @override
//   Future<List<Task>> listTasks(
//     String org,
//     String tok,
//     String assignmentId,
//   ) async {
//     final resp = await _dio.get<List<dynamic>>(
//       '/task/list',
//       queryParameters: {
//         'organization_id': org,
//         'token': tok,
//         'assignment_id': assignmentId,
//       },
//     );
//     return resp.data!
//         .map((j) => Task.fromJson(j as Map<String, dynamic>))
//         .toList();
//   }

//   @override
//   Future<String> createTask(
//     String org,
//     String tok,
//     String assignmentId,
//     TaskRequest req,
//   ) async {
//     final resp = await _dio.post<Map<String, dynamic>>(
//       '/task/teacher',
//       queryParameters: {
//         'organization_id': org,
//         'token': tok,
//         'assignment_id': assignmentId,
//       },
//       data: req.toJson(),
//     );
//     return resp.data!['task_id'] as String;
//   }

//   @override
//   Future<void> deleteTask(String org, String tok, String taskId) =>
//       _dio.delete<void>(
//         '/task/teacher',
//         queryParameters: {
//           'organization_id': org,
//           'token': tok,
//           'task_id': taskId,
//         },
//       );

//   @override
//   Future<void> addQuestionFile(
//     String org,
//     String tok,
//     String taskId,
//     File file,
//   ) =>
//       _dio.post<void>(
//         '/task/teacher/add-file',
//         queryParameters: {
//           'organization_id': org,
//           'token': tok,
//           'task_id': taskId,
//         },
//         data: FormData.fromMap({
//           'file': await MultipartFile.fromFile(
//             file.path,
//             filename: file.path.split('/').last,
//           ),
//         }),
//       );

//   // @override
//   // Future<File> downloadQuestionFile(
//   //   String org,
//   //   String tok,
//   //   String taskId,
//   // ) async {
//   //   final resp = await _dio.get<Uint8List>(
//   //     '/task/question/file',
//   //     queryParameters: {
//   //       'organization_id': org,
//   //       'token': tok,
//   //       'task_id': taskId,
//   //     },
//   //     options: Options(responseType: ResponseType.bytes),
//   //   );
//   //   //
//  final dir = await getApplicationDocumentsDirectory();
//     final filePath = '${dir.path}/${taskId}_$name.pdf';
//     final file = File(filePath);
//     await file.writeAsBytes(bytes);

//     return filePath;
//   // }

//   @override
//   Future<void> answerText(
//     String org,
//     String tok,
//     String assignmentId,
//     String taskId,
//     String text,
//   ) =>
//       _dio.post<void>(
//         '/task/student/answer/text',
//         queryParameters: {
//           'organization_id': org,
//           'token': tok,
//           'assignment_id': assignmentId,
//           'task_id': taskId,
//         },
//         data: {'text': text},
//       );

//   @override
//   Future<void> answerFile(
//     String org,
//     String tok,
//     String assignmentId,
//     String taskId,
//     File file,
//   ) =>
//       _dio.post<void>(
//         '/task/student/answer/file',
//         queryParameters: {
//           'organization_id': org,
//           'token': tok,
//           'assignment_id': assignmentId,
//           'task_id': taskId,
//         },
//         data: FormData.fromMap({
//           'file': await MultipartFile.fromFile(
//             file.path,
//             filename: file.path.split('/').last,
//           ),
//         }),
//       );

//   @override
//   Future<void> evaluateTask(
//     String org,
//     String tok,
//     String assignmentId,
//     String taskId,
//     String userId,
//     int score,
//   ) =>
//       _dio.post<void>(
//         '/task/teacher/evaluate',
//         queryParameters: {
//           'organization_id': org,
//           'token': tok,
//           'assignment_id': assignmentId,
//           'task_id': taskId,
//           'user_id': userId,
//         },
//         data: {'assessment': score},
//       );

//   @override
//   Future<void> feedbackTask(
//     String org,
//     String tok,
//     String assignmentId,
//     String taskId,
//     String userId,
//     String feedback,
//   ) =>
//       _dio.post<void>(
//         '/task/teacher/feedback',
//         queryParameters: {
//           'organization_id': org,
//           'token': tok,
//           'assignment_id': assignmentId,
//           'task_id': taskId,
//           'user_id': userId,
//         },
//         data: {'feedback': feedback},
//       );
@override
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
// @override
//   Future<List<EvaluateAnswers>> fetchEvaluateAnswers(String courseId) async {
//     final org = _orgIdStorage.load() ?? '';
//     final token = _tokenStorage.load() ?? '';
//     final resp = await _dio.get<List<dynamic>>(
//       '/evaluate-answers',
//       queryParameters: {
//         'organization_id': org,
//         'token': token,
//         'course_id': courseId,
//         'assignment_id': assignmentId,
//       },
//     );
//     return resp.data!
//         .map((json) => EvaluateAnswers.fromJson(json as Map<String, dynamic>))
//         .toList();
//   }

import 'dart:io';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:learning_platform/src/feature/profile/model/user_name.dart';
import 'package:learning_platform/src/feature/task/data/data_source/i_tasks_data_source.dart';
import 'package:learning_platform/src/feature/task/file.dart';
import 'package:learning_platform/src/feature/task/model/answer_type.dart';
import 'package:learning_platform/src/feature/task/model/assignment_answers.dart';
import 'package:learning_platform/src/feature/task/model/evaluate_answers.dart';
import 'package:learning_platform/src/feature/task/model/evaluate_task.dart';
import 'package:learning_platform/src/feature/task/model/question_type.dart';
import 'package:learning_platform/src/feature/task/model/student_answer.dart';
import 'package:learning_platform/src/feature/task/model/task.dart';
import 'package:learning_platform/src/feature/task/model/task_request.dart';

class TasksDataSource implements ITasksDataSource {
  final Dio _dio;
  TasksDataSource({required Dio dio}) : _dio = dio;

  final List<Task> _tasks = [
    const Task(
      id: '1',
      questionType: QuestionType.text,
      answerType: AnswerType.text,
      questionText: 'Опишите паттерн MVC.',
      questionFile: '',
      answerVariants: [],
    ),
    const Task(
      id: '2',
      questionType: QuestionType.file,
      answerType: AnswerType.file,
      questionText: 'Загрузите пример UML-диаграммы.',
      questionFile: 'uml_example.png',
      answerVariants: [],
    ),
    const Task(
      id: '3',
      questionType: QuestionType.text,
      answerType: AnswerType.variants,
      questionText: 'Что такое Dependency Injection?',
      questionFile: '',
      answerVariants: [
        'Инверсия управления',
        'Инъекция зависимостей',
        'Оба варианта верны',
      ],
    ),
    const Task(
      id: '4',
      questionType: QuestionType.text,
      answerType: AnswerType.text,
      questionText: 'Перечислите основы ООП.',
      questionFile: '',
      answerVariants: [],
    ),
    const Task(
      id: '5',
      questionType: QuestionType.file,
      answerType: AnswerType.file,
      questionText: 'Прикрепите ваш код на Dart для простого сервиса.',
      questionFile: 'sample_service.dart',
      answerVariants: [],
    ),
  ];

  @override
  Future<List<Task>> listTasks(
    String org,
    String tok,
    String assignmentId,
  ) async =>
      Future.delayed(
        const Duration(milliseconds: 500),
        () => _tasks,
      );

  @override
  Future<String> createTask(
    String org,
    String tok,
    String assignmentId,
    TaskRequest req,
  ) async {
    final newId = (_tasks.length + 1).toString();
    final newTask = Task(
      id: newId,
      questionType: req.questionType,
      questionText: req.questionText ?? '',
      questionFile: '',
      answerType: req.answerType,
      answerVariants: req.answerVariants ?? [],
    );
    _tasks.add(newTask);
    return Future.value(newId);
  }

  @override
  Future<void> deleteTask(String org, String tok, String taskId) async {
    _tasks.removeWhere((t) => t.id == taskId);
    return Future.value();
  }

  @override
  Future<void> addQuestionFile(
    String org,
    String tok,
    String taskId,
    File file,
  ) async {
    final idx = _tasks.indexWhere((t) => t.id == taskId);
    if (idx != -1) {
      _tasks[idx] =
          _tasks[idx].copyWith(questionFile: file.path.split('/').last);
    }
    return Future.value();
  }

  @override
  Future<void> answerText(
    String org,
    String tok,
    String assignmentId,
    String taskId,
    String text,
  ) async =>
      Future.value();

  @override
  Future<void> answerFile(
    String org,
    String tok,
    String assignmentId,
    String taskId,
    File file,
  ) async =>
      Future.value();

  @override
  Future<void> evaluateTask(
    String org,
    String tok,
    String answerId,
    int score,
  ) async =>
      Future.delayed(const Duration(seconds: 1));

  @override
  Future<void> feedbackTask(
    String org,
    String tok,
    String answerId,
    String feedback,
  ) async =>
      Future.delayed(const Duration(seconds: 1));

  @override
  Future<Uint8List> downloadQuestionFile(
    String org,
    String tok,
    String taskId,
  ) async =>
      Future.delayed(
        const Duration(milliseconds: 500),
        () => fileList,
      );

  final List<AssignmentAnswers> _answers = [
    const AssignmentAnswers(
      id: 'a-1',
      name: 'Лексическое значение слов (задание 2)',
      students: [
        StudentAnswer(
          answerId: 'u-101',
          name: UserName(
            firstName: 'Ксения',
            secondName: 'Голубева',
            middleName: 'А',
          ),
          evaluated: true,
        ),
        StudentAnswer(
          answerId: 'u-102',
          name: UserName(
            firstName: 'Адам',
            secondName: 'Бартоломей',
            middleName: 'И',
          ),
          evaluated: false,
        ),
        StudentAnswer(
          answerId: 'u-103',
          name: UserName(
            firstName: 'Татьяна',
            secondName: 'Костюкова',
            middleName: 'П',
          ),
          evaluated: false,
        ),
        StudentAnswer(
          answerId: 'u-104',
          name: UserName(
            firstName: 'Олег',
            secondName: 'Маликов',
            middleName: 'Т',
          ),
          evaluated: true,
        ),
        StudentAnswer(
          answerId: 'u-105',
          name: UserName(
            firstName: 'Эдуард',
            secondName: 'Гафанович',
            middleName: 'М',
          ),
          evaluated: false,
        ),
        StudentAnswer(
          answerId: 'u-106',
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
          answerId: 'u-101',
          name: UserName(
            firstName: 'Ксения',
            secondName: 'Голубева',
            middleName: '',
          ),
          evaluated: true,
        ),
        StudentAnswer(
          answerId: 'u-102',
          name: UserName(
            firstName: 'Адам',
            secondName: 'Бартоломей',
            middleName: 'И',
          ),
          evaluated: true,
        ),
        StudentAnswer(
          answerId: 'u-103',
          name: UserName(
            firstName: 'Татьяна',
            secondName: 'Костюкова',
            middleName: 'П',
          ),
          evaluated: false,
        ),
        StudentAnswer(
          answerId: 'u-104',
          name: UserName(
            firstName: 'Олег',
            secondName: 'Маликов',
            middleName: 'Т',
          ),
          evaluated: false,
        ),
        StudentAnswer(
          answerId: 'u-105',
          name: UserName(
            firstName: 'Эдуард',
            secondName: 'Гафанович',
            middleName: 'М',
          ),
          evaluated: true,
        ),
        StudentAnswer(
          answerId: 'u-106',
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
          answerId: 'u-101',
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

  @override
  Future<EvaluateAnswers> fetchEvaluateAnswers(
    String orgId,
    String token,
    String courseId,
    String assignmentId,
  ) async {
    await Future<void>.delayed(const Duration(seconds: 1));

    return const EvaluateAnswers(
      id: 'assgn1',
      name: 'Лексическое значение слов (задание 2)',
      evaluateTasks: [
        EvaluateTask(
          id: 'task1',
          questionType: QuestionType.text,
          answerType: AnswerType.text,
          questionText:
              'Укажите варианты ответов, в которых во всех словах одного ряда пропущена одна и та же буква. Запишите номера ответов.',
          answerText: '124',
          evaluate: '6',
          feedback: 'Правильный ответ: 124',
        ),
        EvaluateTask(
          id: 'task2',
          questionType: QuestionType.file,
          answerType: AnswerType.file,
          questionFile: 'Структура_сочинения.pdf',
          answerFile: 'ответ_Голубева_КА.pdf',
          evaluate: '7',
        ),
        EvaluateTask(
          id: 'task3',
          questionType: QuestionType.text,
          answerType: AnswerType.variants,
          questionText:
              'Выберите варианты ответов, в которых верно выделена буква, обозначающая ударный гласный звук.',
          answerVariants: [
            '1) туфлЯ',
            '2) понЯв',
            '3) дОнельзя',
            '4) карыстЬ',
            '5) Оптовый',
          ],
          answerVariant: 2,
          evaluate: '5',
          feedback: 'Правильный ответ: 1',
        ),
        EvaluateTask(
          id: 'task4',
          questionType: QuestionType.text,
          answerType: AnswerType.text,
          questionText:
              'Составьте собственное предложение со словом «симп.Тичный» и запишите его.',
          answerText: 'Это было очень симп.тичное решение задачи.',
          evaluate: '10',
          feedback: 'Отлично молодец!',
        ),
      ],
    );
  }
}
