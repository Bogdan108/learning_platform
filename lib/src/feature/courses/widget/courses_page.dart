// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:learning_platform/src/feature/courses/bloc/courses_bloc.dart';
import 'package:learning_platform/src/feature/courses/bloc/courses_bloc_state.dart';

class CoursesPage extends StatefulWidget {
  const CoursesPage({super.key});

  @override
  State<CoursesPage> createState() => _TeacherCoursesPageState();
}

class _TeacherCoursesPageState extends State<CoursesPage> {
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Мои курсы'),
          centerTitle: true,
          actions: [
            IconButton(
              icon: const Icon(Icons.person),
              onPressed: () => context.push('/profile'),
            ),
          ],
        ),
        body: BlocBuilder<CoursesBloc, CoursesBlocState>(
          builder: (context, state) => ListView.separated(
            itemCount: state.courses.length,
            separatorBuilder: (context, index) => const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Divider(
                color: Colors.blue,
              ),
            ),
            itemBuilder: (context, index) {
              final course = state.courses[index];
              return GestureDetector(
                onTap: () =>
                    context.go('/courses/course_details', extra: course),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 16,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            course.name,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            course.isActive ? 'Активен' : 'Неактивен',
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.blue,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        course.description,
                        style: const TextStyle(fontSize: 14),
                      ),
                      // const SizedBox(height: 4),
                      // Text(
                      //   '${course.studentCount} учеников',
                      //   style: const TextStyle(
                      //     fontSize: 12,
                      //     color: Colors.grey,
                      //   ),
                      // ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        // floatingActionButton: FloatingActionButton(
        //   onPressed: () => _showAddCourseDialog(context),
        //   child: const Icon(Icons.add),
        // ),
      );

  Future<void> _showAddCourseDialog(BuildContext context) async {
    final titleController = TextEditingController();
    final descController = TextEditingController();

    // ignore: inference_failure_on_function_invocation
    await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Добавить новый курс'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(labelText: 'Название курса'),
              ),
              TextField(
                controller: descController,
                decoration: const InputDecoration(labelText: 'Описание'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Отмена'),
          ),
          TextButton(
            onPressed: () {
              // final title = titleController.text.trim();
              // final description = descController.text.trim();

              Navigator.pop(ctx);
            },
            child: const Text('Сохранить'),
          ),
        ],
      ),
    );
  }
}
