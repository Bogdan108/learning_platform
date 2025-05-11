import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:learning_platform/src/feature/assignment/model/assignment_courses.dart';
import 'package:learning_platform/src/feature/assignment/model/assignment_status.dart';

class StudentAssignmentWidget extends StatelessWidget {
  final AssignmentCourses course;
  const StudentAssignmentWidget({required this.course, super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Заголовок раздела
        const Divider(
          color: Colors.blue,
          thickness: 1,
          indent: 16,
          endIndent: 16,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 8,
            horizontal: 16,
          ),
          child: Text(
            course.courseName,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.blue,
            ),
          ),
        ),
        const Divider(
          color: Colors.blue,
          thickness: 1,
          indent: 16,
          endIndent: 16,
        ),
        // Список заданий
        for (final asg in course.assignments) ...[
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 8,
            ),
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: const Color(
                  0xFFE2F2FF,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: ListTile(
                title: Text(
                  asg.name,
                  style: const TextStyle(fontSize: 16),
                ),
                subtitle: Text(
                  asg.status.statusText,
                  style: TextStyle(
                    color: asg.status.statusColor,
                  ),
                ),
                trailing: const Icon(
                  Icons.arrow_forward_ios,
                  size: 18,
                  color: Colors.blue,
                ),
                onTap: () {
                  if (asg.status == AssignmentStatus.pending) {
                    context.pushNamed(
                      'answerAssignment',
                      pathParameters: {'assignmentId': asg.id},
                      extra: asg.name,
                    );
                  } else {
                    context.pushNamed(
                      'studentEvaluateAnswers',
                      pathParameters: {'answerId': asg.id},
                      extra: asg.name,
                    );
                  }
                },
              ),
            ),
          ),
        ],
        const SizedBox(height: 16),
      ],
    );
  }
}
