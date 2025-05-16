// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_platform/src/core/widget/custom_snackbar.dart';
import 'package:learning_platform/src/feature/initialization/widget/dependencies_scope.dart';
import 'package:learning_platform/src/feature/profile/model/user_role.dart';
import 'package:learning_platform/src/feature/task/bloc/evaluate_tasks_bloc/evaluate_assignment_bloc.dart';
import 'package:learning_platform/src/feature/task/bloc/evaluate_tasks_bloc/evaluate_tasks_event.dart';
import 'package:learning_platform/src/feature/task/data/repository/tasks_repository.dart';
import 'package:learning_platform/src/feature/task/model/answer_type.dart';
import 'package:learning_platform/src/feature/task/model/evaluate_task.dart';
import 'package:learning_platform/src/feature/task/model/question_type.dart';
import 'package:learning_platform/src/feature/task/widget/components/evaluate_task_dialog.dart';
import 'package:learning_platform/src/feature/task/widget/components/evaluation_widget.dart';
import 'package:share_plus/share_plus.dart';

class EvaluateTaskTile extends StatelessWidget {
  final int number;
  final EvaluateTask task;
  final String assignmentId;
  final TasksRepository tasksRepository;
  final String? userId;

  const EvaluateTaskTile({
    required this.number,
    required this.task,
    required this.assignmentId,
    required this.tasksRepository,
    this.userId,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final evaluateBloc = context.read<EvaluateTasksBloc>();
    final role =
        DependenciesScope.of(context).profileBloc.state.profileInfo.role;
    final isTeacher = role == UserRole.teacher;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 24,
                height: 24,
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.all(
                    Radius.circular(8),
                  ),
                ),
                child: Text(
                  number.toString(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              switch (task.questionType) {
                QuestionType.text => Expanded(
                    child: Text(
                      task.questionText ?? '',
                      style: const TextStyle(fontSize: 14),
                    ),
                  ),
                QuestionType.file => Expanded(
                    child: Row(
                      children: [
                        const Icon(
                          Icons.insert_drive_file,
                          color: Colors.blue,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            task.questionFile ?? 'Прикреплён файл',
                            style: const TextStyle(fontSize: 14),
                          ),
                        ),
                        const Spacer(),
                        // Скачивание файла
                        GestureDetector(
                          child: const Icon(Icons.download),
                          onTap: () async {
                            CustomSnackBar.showSuccessful(
                              context,
                              title: 'Скачиваем ...',
                            );

                            try {
                              final filePath =
                                  await tasksRepository.downloadQuestionFile(
                                task.id,
                                task.questionFile,
                              );

                              if (filePath != null) {
                                final params = ShareParams(
                                  title: task.questionFile,
                                  files: [XFile(filePath)],
                                );

                                await SharePlus.instance.share(params);
                              }
                            } catch (e) {
                              CustomSnackBar.showError(
                                context,
                                title: 'Ошибка: $e',
                              );
                            }
                          },
                        ),
                      ],
                    ),
                  ),
              },
              if (isTeacher) ...[
                const SizedBox(
                  width: 18,
                ),
                GestureDetector(
                  child: const Icon(
                    Icons.edit_outlined,
                  ),
                  onTap: () => EvaluateTaskDialog(
                    onSaveCallback: (score, feedback) => evaluateBloc.add(
                      EvaluateTasksEvent.evaluate(
                        taskId: task.id,
                        assignmentId: assignmentId,
                        userId: userId ?? '-1',
                        score: score,
                        feedback: feedback,
                      ),
                    ),
                  ).show(
                    context,
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 25),
          switch (task.answerType) {
            AnswerType.text => Container(
                margin: const EdgeInsets.only(bottom: 4),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: Colors.blue,
                    width: 2,
                  ),
                ),
                child: Row(
                  children: [
                    Text(task.answerText ?? ''),
                  ],
                ),
              ),
            AnswerType.file => Container(
                margin: const EdgeInsets.only(bottom: 4),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: Colors.blue,
                    width: 2,
                  ),
                ),
                child: Row(
                  spacing: 12,
                  children: [
                    const Icon(
                      Icons.attach_file,
                      size: 20,
                    ),
                    Text(task.answerFile ?? ''),
                    const Spacer(),
                    // Скачивание файла
                    GestureDetector(
                      child: const Icon(Icons.download),
                      onTap: () async {
                        CustomSnackBar.showSuccessful(
                          context,
                          title: 'Скачиваем ...',
                        );

                        try {
                          final filePath =
                              await tasksRepository.downloadAnswerFile(
                            assignmentId: assignmentId,
                            taskId: task.id,
                            userId: userId ?? '-1',
                            name: task.answerFile,
                          );

                          if (filePath != null) {
                            final params = ShareParams(
                              title: task.questionFile,
                              files: [XFile(filePath)],
                            );

                            await SharePlus.instance.share(params);
                          }
                        } catch (e) {
                          CustomSnackBar.showError(
                            context,
                            title: 'Ошибка: $e',
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
            AnswerType.variants => Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: task.answerVariants?.map(
                        (variant) {
                          final isSelected = task.answerText == variant;

                          return Container(
                            margin: const EdgeInsets.only(bottom: 4),
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: isSelected ? Colors.blue : Colors.white,
                              border: Border.all(
                                color: Colors.blue,
                                width: 2,
                              ),
                            ),
                            child: Row(
                              children: [
                                Text(variant),
                              ],
                            ),
                          );
                        },
                      ).toList() ??
                      [],
                ),
              ),
          },
          if (task.assessment != null) ...[
            const SizedBox(height: 10),
            EvaluationWidget(
              score: task.assessment!,
              comment: task.feedback,
            ),
          ],
        ],
      ),
    );
  }
}
