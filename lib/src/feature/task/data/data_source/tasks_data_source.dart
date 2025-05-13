// ignore_for_file: inference_failure_on_function_invocation

// import 'dart:typed_data';
// import 'package:dio/dio.dart';
// import 'package:learning_platform/src/feature/task/data/data_source/i_tasks_data_source.dart';
// import 'package:learning_platform/src/feature/task/model/evaluate_answers.dart';
// import 'package:learning_platform/src/feature/task/model/task.dart';
// import 'package:learning_platform/src/feature/task/model/task_request.dart';

// class TasksDataSource implements ITasksDataSource {
//   final Dio _dio;
//   TasksDataSource({required Dio dio}) : _dio = dio;

//   @override
//   Future<List<Task>> getTasks({
//     required String organizationId,
//     required String token,
//     required String assignmentId,
//   }) async {
//     final response = await _dio.get<List<dynamic>>(
//       '/task/list',
//       queryParameters: {
//         'organization_id': organizationId,
//         'token': token,
//         'assignment_id': assignmentId,
//       },
//     );
//     return response.data?.map((e) => Task.fromJson(e as Map<String, dynamic>)).toList() ?? [];
//   }

//   @override
//   Future<String> createTask({
//     required String organizationId,
//     required String token,
//     required String assignmentId,
//     required TaskRequest task,
//   }) async {
//     final response = await _dio.post<Map<String, dynamic>>(
//       '/task/teacher',
//       queryParameters: {
//         'organization_id': organizationId,
//         'token': token,
//         'assignment_id': assignmentId,
//       },
//       data: task.toJson(),
//     );
//     final data = response.data;
//     if (data != null && data.containsKey('task_id')) {
//       return data['task_id'] as String;
//     }
//     throw Exception('Failed to create task');
//   }

//   @override
//   Future<void> deleteTask({
//     required String organizationId,
//     required String token,
//     required String taskId,
//   }) =>
//       _dio.delete(
//         '/task/teacher',
//         queryParameters: {
//           'organization_id': organizationId,
//           'token': token,
//           'task_id': taskId,
//         },
//       );

//   @override
//   Future<void> addFileToTask({
//     required String organizationId,
//     required String token,
//     required String taskId,
//     required Uint8List fileBytes,
//     required String filename,
//   }) async {
//     final form = FormData.fromMap({
//       'file': MultipartFile.fromBytes(
//         fileBytes,
//         filename: filename,
//       ),
//     });
//     await _dio.post(
//       '/task/teacher/add-file',
//       queryParameters: {
//         'organization_id': organizationId,
//         'token': token,
//         'task_id': taskId,
//       },
//       data: form,
//     );
//   }

//   @override
//   Future<Uint8List> downloadQuestionFile({
//     required String organizationId,
//     required String token,
//     required String taskId,
//   }) async {
//     final resp = await _dio.get<Uint8List>(
//       '/task/question/file',
//       options: Options(responseType: ResponseType.bytes),
//       queryParameters: {
//         'organization_id': organizationId,
//         'token': token,
//         'task_id': taskId,
//       },
//     );
//     return resp.data ?? Uint8List.fromList([]);
//   }

//   @override
//   Future<void> answerText({
//     required String organizationId,
//     required String token,
//     required String assignmentId,
//     required String taskId,
//     required String answer,
//   }) =>
//       _dio.post(
//         '/task/student/answer/text',
//         queryParameters: {
//           'organization_id': organizationId,
//           'token': token,
//           'assignment_id': assignmentId,
//           'task_id': taskId,
//         },
//         data: {'text': answer},
//       );

//   @override
//   Future<void> answerFile({
//     required String organizationId,
//     required String token,
//     required String assignmentId,
//     required String taskId,
//     required Uint8List fileBytes,
//     required String filename,
//   }) async {
//     final form = FormData.fromMap({
//       'file': MultipartFile.fromBytes(
//         fileBytes,
//         filename: filename,
//       ),
//     });
//     await _dio.post(
//       '/task/student/answer/file',
//       queryParameters: {
//         'organization_id': organizationId,
//         'token': token,
//         'assignment_id': assignmentId,
//         'task_id': taskId,
//       },
//       data: form,
//     );
//   }

//   @override
//   Future<void> evaluateTask({
//     required String organizationId,
//     required String token,
//     required String assignmentId,
//     required String taskId,
//     required String userId,
//     required int evaluation,
//   }) =>
//       _dio.post(
//         '/task/teacher/evaluate',
//         queryParameters: {
//           'organization_id': organizationId,
//           'token': token,
//           'assignment_id': assignmentId,
//           'task_id': taskId,
//           'user_id': userId,
//         },
//         data: {'assessment': evaluation},
//       );

//   @override
//   Future<void> feedbackTask({
//     required String organizationId,
//     required String token,
//     required String assignmentId,
//     required String taskId,
//     required String userId,
//     required String feedback,
//   }) =>
//       _dio.post(
//         '/task/teacher/feedback',
//         queryParameters: {
//           'organization_id': organizationId,
//           'token': token,
//           'assignment_id': assignmentId,
//           'task_id': taskId,
//           'user_id': userId,
//         },
//         data: {'feedback': feedback},
//       );

//   @override
//   Future<Uint8List> downloadAnswerFile({
//     required String organizationId,
//     required String token,
//     required String assignmentId,
//     required String taskId,
//     required String userId,
//   }) async {
//     final resp = await _dio.get<Uint8List>(
//       '/task/answer/file',
//       options: Options(responseType: ResponseType.bytes),
//       queryParameters: {
//         'organization_id': organizationId,
//         'token': token,
//         'assignment_id': assignmentId,
//         'task_id': taskId,
//         'user_id': userId,
//       },
//     );
//     return resp.data!;
//   }

//   @override
//   Future<EvaluateAnswers> fetchStudentEvaluateAnswers({
//     required String organizationId,
//     required String token,
//     required String assignmentId,
//   }) async {
//     final resp = await _dio.get<Map<String, dynamic>>(
//       '/assignment/student/info',
//       queryParameters: {
//         'organization_id': organizationId,
//         'token': token,
//         'assignment_id': assignmentId,
//       },
//     );
//     return EvaluateAnswers.fromJson(resp as Map<String, dynamic>);
//   }

//   @override
//   Future<EvaluateAnswers> fetchTeacherEvaluateAnswers({
//     required String organizationId,
//     required String token,
//     required String userId,
//     required String assignmentId,
//   }) async {
//     final resp = await _dio.get<Map<String, dynamic>>(
//       '/assignment/teacher/info',
//       queryParameters: {
//         'organization_id': organizationId,
//         'token': token,
//         'assignment_id': assignmentId,
//         'user_id': userId,
//       },
//     );
//     return EvaluateAnswers.fromJson(resp as Map<String, dynamic>);
//   }
// }

import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:learning_platform/src/feature/task/data/data_source/i_tasks_data_source.dart';
import 'package:learning_platform/src/feature/task/file.dart';
import 'package:learning_platform/src/feature/task/model/answer_type.dart';
import 'package:learning_platform/src/feature/task/model/evaluate_answers.dart';
import 'package:learning_platform/src/feature/task/model/evaluate_task.dart';
import 'package:learning_platform/src/feature/task/model/question_type.dart';
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
  Future<List<Task>> getTasks({
    required String organizationId,
    required String token,
    required String assignmentId,
  }) async =>
      Future.delayed(
        const Duration(milliseconds: 500),
        () => _tasks,
      );

  @override
  Future<String> createTask({
    required String organizationId,
    required String token,
    required String assignmentId,
    required TaskRequest task,
  }) async {
    final newId = (_tasks.length + 1).toString();
    final newTask = Task(
      id: newId,
      questionType: task.questionType,
      questionText: task.questionText ?? '',
      questionFile: '',
      answerType: task.answerType,
      answerVariants: task.answerVariants ?? [],
    );
    _tasks.add(newTask);
    return Future.value(newId);
  }

  @override
  Future<void> deleteTask({
    required String organizationId,
    required String token,
    required String taskId,
  }) async {
    _tasks.removeWhere((t) => t.id == taskId);
    return Future.value();
  }

  @override
  Future<void> addFileToTask({
    required String organizationId,
    required String token,
    required String taskId,
    required Uint8List fileBytes,
    required String filename,
  }) async {
    return Future.delayed(
      const Duration(seconds: 1),
    );
  }

  @override
  Future<void> answerText({
    required String organizationId,
    required String token,
    required String assignmentId,
    required String taskId,
    required String answer,
  }) async =>
      Future.delayed(
        const Duration(seconds: 1),
      );

  @override
  Future<void> answerFile({
    required String organizationId,
    required String token,
    required String assignmentId,
    required String taskId,
    required Uint8List fileBytes,
    required String filename,
  }) async =>
      Future.delayed(
        const Duration(seconds: 1),
      );

  @override
  Future<void> evaluateTask({
    required String organizationId,
    required String token,
    required String assignmentId,
    required String taskId,
    required String userId,
    required int evaluation,
  }) async =>
      Future.delayed(const Duration(seconds: 1));

  @override
  Future<void> feedbackTask({
    required String organizationId,
    required String token,
    required String assignmentId,
    required String taskId,
    required String userId,
    required String feedback,
  }) async =>
      Future.delayed(const Duration(seconds: 1));

  @override
  Future<Uint8List> downloadQuestionFile({
    required String organizationId,
    required String token,
    required String taskId,
  }) async =>
      Future.delayed(
        const Duration(milliseconds: 500),
        () => fileList,
      );

  @override
  Future<EvaluateAnswers> fetchTeacherEvaluateAnswers({
    required String organizationId,
    required String token,
    required String userId,
    required String assignmentId,
  }) async {
    await Future<void>.delayed(const Duration(seconds: 1));

    return const EvaluateAnswers(
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
          questionText: 'Составьте собственное предложение со словом «симп.Тичный» и запишите его.',
          answerText: 'Это было очень симп.тичное решение задачи.',
          evaluate: '10',
          feedback: 'Отлично молодец!',
        ),
      ],
    );
  }

  @override
  Future<EvaluateAnswers> fetchStudentEvaluateAnswers({
    required String organizationId,
    required String token,
    required String assignmentId,
  }) async {
    await Future<void>.delayed(const Duration(seconds: 1));

    return const EvaluateAnswers(
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
          questionText: 'Составьте собственное предложение со словом «симп.Тичный» и запишите его.',
          answerText: 'Это было очень симп.тичное решение задачи.',
          evaluate: '10',
          feedback: 'Отлично молодец!',
        ),
      ],
    );
  }

  @override
  Future<Uint8List> downloadAnswerFile(
          {required String organizationId,
          required String token,
          required String assignmentId,
          required String taskId,
          required String userId}) async =>
      Future.delayed(
        const Duration(milliseconds: 500),
        () => fileList,
      );
}
