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
// }

import 'dart:io';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:learning_platform/src/feature/task/data/data_source/i_tasks_data_source.dart';
import 'package:learning_platform/src/feature/task/file.dart';
import 'package:learning_platform/src/feature/task/model/answer_type.dart';
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
    String assignmentId,
    String taskId,
    String userId,
    int score,
  ) async =>
      Future.value();

  @override
  Future<void> feedbackTask(
    String org,
    String tok,
    String assignmentId,
    String taskId,
    String userId,
    String feedback,
  ) async =>
      Future.value();

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
}
