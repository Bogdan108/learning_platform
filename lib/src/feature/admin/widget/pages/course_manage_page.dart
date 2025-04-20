// // ignore_for_file: prefer_const_constructors

// import 'package:flutter/material.dart';
// import 'package:learning_platform/src/feature/course/model/course.dart';
// import 'package:learning_platform/src/feature/course/model/course_model.dart';

// class AdminCourseManagementPage extends StatefulWidget {
//   const AdminCourseManagementPage({Key? key}) : super(key: key);

//   @override
//   State<AdminCourseManagementPage> createState() =>
//       _AdminCourseManagementPageState();
// }

// class _AdminCourseManagementPageState extends State<AdminCourseManagementPage> {
//   final TextEditingController _searchController = TextEditingController();

//   @override
//   void dispose() {
//     _searchController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final query = _searchController.text.toLowerCase();
//     final filteredCourses = _courses
//         .where((course) => course.title.toLowerCase().contains(query))
//         .toList();

//     return Column(
//       children: [
//         Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: TextField(
//             controller: _searchController,
//             decoration: const InputDecoration(
//               labelText: 'Поиск',
//               prefixIcon: Icon(Icons.search),
//               border: OutlineInputBorder(),
//             ),
//             onChanged: (value) => setState(() {}),
//           ),
//         ),
//         Expanded(
//           child: ListView.separated(
//             itemCount: filteredCourses.length,
//             separatorBuilder: (context, index) => Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 20),
//               child: const Divider(
//                 height: 1,
//                 color: Colors.blue,
//               ),
//             ),
//             itemBuilder: (context, index) {
//               final course = filteredCourses[index];
//               return ListTile(
//                 title: Text(course.title),
//                 subtitle: Text(
//                   '${course.description}\nСтатус: ${course.status}',
//                 ),
//                 isThreeLine: true,
//                 trailing: Row(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     IconButton(
//                       icon: const Icon(Icons.autorenew),
//                       onPressed: () => _showChangeStatusDialog(course),
//                     ),
//                     IconButton(
//                       icon: const Icon(Icons.delete),
//                       onPressed: () => _showDeleteCourseDialog(course),
//                     ),
//                   ],
//                 ),
//               );
//             },
//           ),
//         ),
//       ],
//     );
//   }

//   void _showChangeStatusDialog(Course course) {
//     showDialog(
//       context: context,
//       builder: (_) => AlertDialog(
//         title: const Text('Изменить статус курса'),
//         content: const Text('Сделать курс активным или завершённым?'),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: const Text('Отмена'),
//           ),
//           TextButton(
//             onPressed: () {
//               setState(() {
//                 final index = _courses.indexOf(course);
//                 _courses[index] = course.copyWith(status: 'Активен');
//               });
//               Navigator.pop(context);
//             },
//             child: const Text('Активировать'),
//           ),
//           TextButton(
//             onPressed: () {
//               setState(() {
//                 final index = _courses.indexOf(course);
//                 _courses[index] = course.copyWith(status: 'Завершён');
//               });
//               Navigator.pop(context);
//             },
//             child: const Text('Завершить'),
//           ),
//         ],
//       ),
//     );
//   }

//   void _showDeleteCourseDialog(Course course) {
//     showDialog(
//       context: context,
//       builder: (_) => AlertDialog(
//         title: Text('Вы хотите удалить «${course.title}»?'),
//         content: const Text('Действие необратимо. Удалить курс?'),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: const Text('Отмена'),
//           ),
//           TextButton(
//             onPressed: () {
//               setState(() {
//                 _courses.remove(course);
//               });
//               Navigator.pop(context);
//             },
//             child: const Text('Удалить'),
//           ),
//         ],
//       ),
//     );
//   }
// }
