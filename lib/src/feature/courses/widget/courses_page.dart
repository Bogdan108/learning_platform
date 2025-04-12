// // ignore_for_file: prefer_const_constructors

// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
// import 'package:learning_platform/src/feature/courses/model/course_model.dart';

// class CoursesPage extends StatefulWidget {
//   const CoursesPage({Key? key}) : super(key: key);

//   @override
//   State<CoursesPage> createState() => _TeacherCoursesPageState();
// }

// class _TeacherCoursesPageState extends State<CoursesPage> {
//   final List<Course> _courses = [
//     Course(
//       title: 'Русский язык',
//       description: 'Курс по русскому языку для подготовки к ЕГЭ',
//       studentCount: 4,
//       status: 'Активен',
//       materials: [
//         'Правила.pdf',
//         'Структура сочинения.pdf',
//         'Полезные шпаргалки.pdf',
//         'https://ege.sdamgia.ru/',
//       ],
//       students: [
//         'Голубева К. А.',
//         'Бартоломей А. И.',
//         'Костюкова Т. П.',
//         'Маликов Т. О.',
//       ],
//     ),
//     Course(
//       title: 'Литература',
//       description: 'Углублённый курс для подготовки к вступительным экзаменам',
//       materials: [
//         'Программа курса.pdf',
//         'Список литературы.docx',
//       ],
//       studentCount: 2,
//       status: 'Активен',
//       students: [
//         'Иванов И. И.',
//         'Петров П. П.',
//       ],
//     ),
//   ];

//   @override
//   Widget build(BuildContext context) => Scaffold(
//         appBar: AppBar(
//           title: const Text('Мои курсы'),
//           centerTitle: true,
//           actions: [
//             IconButton(
//               icon: const Icon(Icons.person),
//               onPressed: () => context.push('/profile'),
//             ),
//           ],
//         ),
//         body: ListView.separated(
//           itemCount: _courses.length,
//           separatorBuilder: (context, index) => const Padding(
//             padding: EdgeInsets.symmetric(horizontal: 20),
//             child: Divider(
//               color: Colors.blue,
//             ),
//           ),
//           itemBuilder: (context, index) {
//             final course = _courses[index];
//             return GestureDetector(
//               onTap: () => context.go('/courses/details', extra: course),
//               child: Padding(
//                 padding:
//                     const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Text(
//                           course.title,
//                           style: const TextStyle(
//                             fontSize: 16,
//                             fontWeight: FontWeight.w600,
//                           ),
//                         ),
//                         Text(
//                           course.status,
//                           style: const TextStyle(
//                             fontSize: 14,
//                             color: Colors.blue,
//                           ),
//                         ),
//                       ],
//                     ),
//                     const SizedBox(height: 4),
//                     Text(
//                       course.description,
//                       style: const TextStyle(fontSize: 14),
//                     ),
//                     const SizedBox(height: 4),
//                     Text(
//                       '${course.studentCount} учеников',
//                       style: const TextStyle(
//                         fontSize: 12,
//                         color: Colors.grey,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             );
//           },
//         ),
//         // floatingActionButton: FloatingActionButton(
//         //   onPressed: () => _showAddCourseDialog(context),
//         //   child: const Icon(Icons.add),
//         // ),
//       );

//   Future<void> _showAddCourseDialog(BuildContext context) async {
//     final titleController = TextEditingController();
//     final descController = TextEditingController();

//     // ignore: inference_failure_on_function_invocation
//     await showDialog(
//       context: context,
//       builder: (ctx) => AlertDialog(
//         title: const Text('Добавить новый курс'),
//         content: SingleChildScrollView(
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               TextField(
//                 controller: titleController,
//                 decoration: const InputDecoration(labelText: 'Название курса'),
//               ),
//               TextField(
//                 controller: descController,
//                 decoration: const InputDecoration(labelText: 'Описание'),
//               ),
//             ],
//           ),
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(ctx),
//             child: const Text('Отмена'),
//           ),
//           TextButton(
//             onPressed: () {
//               final title = titleController.text.trim();
//               final description = descController.text.trim();

//               setState(
//                 () {
//                   _courses.add(
//                     Course(
//                       title: title,
//                       description: description,
//                       studentCount: 0,
//                       status: 'Активен',
//                       materials: [],
//                       students: [],
//                     ),
//                   );
//                 },
//               );
//               Navigator.pop(ctx);
//             },
//             child: const Text('Сохранить'),
//           ),
//         ],
//       ),
//     );
//   }
// }
