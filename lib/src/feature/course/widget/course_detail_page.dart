import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_platform/src/feature/course/bloc/course_bloc.dart';
import 'package:learning_platform/src/feature/course/bloc/course_bloc_state.dart';
import 'package:learning_platform/src/feature/courses/model/course.dart';

class CourseDetailPage extends StatelessWidget {
  final Course courseDetails;

  const CourseDetailPage({
    required this.courseDetails,
    super.key,
  });

  @override
  Widget build(BuildContext context) =>
      BlocBuilder<CourseBloc, CourseBlocState>(
        builder: (context, state) => Scaffold(
          appBar: AppBar(
            title: Text(courseDetails.name),
            centerTitle: true,
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  courseDetails.description,
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
                for (final link in state.additions.links)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Row(
                      children: [
                        Text(
                          link.name,
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
                for (final material in state.additions.materials)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Row(
                      children: [
                        Text(
                          material.name,
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
                  child: const Text(
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
        ),
      );
}
