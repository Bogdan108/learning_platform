import 'package:flutter/material.dart';
import 'package:learning_platform/src/feature/courses/model/course.dart';

class CourseDetailPage extends StatelessWidget {
  final Course course;

  const CourseDetailPage({
    Key? key,
    required this.course,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text(course.title),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                course.description,
                style: const TextStyle(fontSize: 16),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: Divider(
                  color: Colors.blue,
                ),
              ),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Материалы к курсу',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.blue,
                    ),
                  ),
                  // IconButton(
                  //   icon: const Icon(Icons.add),
                  //   onPressed: () {},
                  // ),
                ],
              ),
              const SizedBox(height: 8),
              for (final material in course.materials)
                Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Row(
                    children: [
                      Text(
                        material,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      const Icon(
                        Icons.download,
                      ),
                    ],
                  ),
                ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: Divider(
                  color: Colors.blue,
                ),
              ),
              // const Text(
              //   'Ученики',
              //   style: TextStyle(
              //     fontSize: 16,
              //     fontWeight: FontWeight.w600,
              //     color: Colors.blue,
              //   ),
              // ),
              // const SizedBox(height: 8),
              // for (final student in course.students)
              //   Padding(
              //     padding: const EdgeInsets.only(bottom: 4),
              //     child: Text(student),
              //   ),
              TextButton(
                onPressed: () => {},
                child: Text(
                  'Выйти из курса',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.blue,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
}
