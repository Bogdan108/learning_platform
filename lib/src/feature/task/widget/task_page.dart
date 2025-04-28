// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:go_router/go_router.dart';
// import 'package:learning_platform/src/feature/initialization/widget/dependencies_scope.dart';
// import 'package:learning_platform/src/feature/task/bloc/tasks_bloc.dart';
// import 'package:learning_platform/src/feature/task/bloc/tasks_bloc_event.dart';
// import 'package:learning_platform/src/feature/task/bloc/tasks_bloc_state.dart';
// import 'package:learning_platform/src/feature/task/data/data_source/tasks_data_source.dart';
// import 'package:learning_platform/src/feature/task/data/repository/tasks_repository.dart';
// import 'package:learning_platform/src/feature/task/model/task_request.dart';
// import 'package:learning_platform/src/feature/task/widget/components/answer_task.dart';
// import 'package:learning_platform/src/feature/task/widget/components/create_task.dart';

// class TasksPage extends StatefulWidget {
//   final String assignmentId;
//   const TasksPage({ required this.assignmentId, super.key });

//   @override
//   State<TasksPage> createState() => _TasksPageState();
// }

// class _TasksPageState extends State<TasksPage> {
//   late final TasksBloc _bloc;

//   @override
//   void initState() {
//     super.initState();
//     final deps = DependenciesScope.of(context);
//     _bloc = TasksBloc(
//       repo: TasksRepository(
//         dataSource: TasksDataSource(dio: deps.dio),
//         tokenStorage: deps.tokenStorage,
//         orgIdStorage: deps.organizationIdStorage,
//       ),
//     )..add(TasksBlocEvent.fetch(widget.assignmentId));
//   }

//   @override
//   Widget build(BuildContext context) => Scaffold(
//       appBar: AppBar(title: const Text('Задачи')),
//       body: BlocBuilder<TasksBloc, TasksBlocState>(
//         bloc: _bloc,
//         builder: (_, state) => ListView.separated(
//           itemCount: state.tasks.length + 1,
//           separatorBuilder: (_,__) => const Divider(color: Colors.grey),
//           itemBuilder: (_, idx) {
//             if (idx == state.tasks.length) {
//               return Padding(
//                 padding: const EdgeInsets.all(16),
//                 child: ElevatedButton(
//                   child: const Text('Добавить задачу'),
//                   onPressed: () {
//                     CreateTaskDialog(onSave: (qType, qText, aType, variants) {
//                       _bloc.add(TasksBlocEvent.create(
//                         assignmentId: widget.assignmentId,
//                         req: TaskRequest(
//                           questionType: qType,
//                           questionText: qText,
//                           answerType: aType,
//                           answerVariants: variants,
//                         ),
//                       ),);
//                     },).show(context);
//                   },
//                 ),
//               );
//             }

//             final t = state.tasks[idx];
//             return ListTile(
//               title: t.questionType == 'text'
//                   ? Text(t.questionText ?? '')
//                   : const Icon(Icons.insert_drive_file),
//               subtitle: Text('Ответ: ${t.answerType}'),
//               onTap: () {
//                 // choose either answer or evaluate depending on role
//                 final isTeacher = /* read from profileBloc */;
//                 if (isTeacher) {
//                   // show evaluation UI
//                 } else {
//                   if (t.answerType == 'text') {
//                     AnswerTaskDialog(onSubmit: (txt) {
//                       _bloc.add(TasksBlocEvent.answerText(
//                         assignmentId: widget.assignmentId,
//                         taskId: t.id,
//                         text: txt,
//                       ),);
//                     },).show(context);
//                   } else {
//                     AnswerTaskDialog(onSubmit: (file) {
//                       _bloc.add(TasksBlocEvent.answerFile(
//                         assignmentId: widget.assignmentId,
//                         taskId: t.id,
//                         file: file,
//                       ),);
//                     },).show(context);
//                   }
//                 }
//               },
//               trailing: IconButton(
//                 icon: const Icon(Icons.delete, color: Colors.red),
//                 onPressed: () {
//                   // DeleteTaskDialog(onConfirm: () {
//                   //   _bloc.add(TasksBlocEvent.delete(t.id));
//                   // },).show(context);
//                 },
//               ),
//             );
//           },
//         ),
//       ),
//     );
// }
