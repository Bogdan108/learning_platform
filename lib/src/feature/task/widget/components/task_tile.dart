import 'package:flutter/material.dart';
import 'package:learning_platform/src/common/widget/custom_snackbar.dart';
import 'package:learning_platform/src/feature/task/data/repository/tasks_repository.dart';
import 'package:learning_platform/src/feature/task/model/answer_type.dart';
import 'package:learning_platform/src/feature/task/model/question_type.dart';
import 'package:learning_platform/src/feature/task/model/task.dart';
import 'package:share_plus/share_plus.dart';

class TaskTile extends StatelessWidget {
  final int number;
  final Task task;
  final VoidCallback onDeleteTask;
  final TasksRepository tasksRepository;

  const TaskTile({
    required this.number,
    required this.task,
    required this.onDeleteTask,
    required this.tasksRepository,
    super.key,
  });

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
                                );
                                final params = ShareParams(
                                  title: task.questionFile,
                                  files: [XFile(filePath)],
                                );

                                await SharePlus.instance.share(params);
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
                const SizedBox(width: 10),
                GestureDetector(
                  onTap: onDeleteTask,
                  child: const Icon(
                    Icons.delete,
                    color: Color(0xFFC1121F),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 25),
            switch (task.answerType) {
              AnswerType.text => Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Container(
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
                    child: const Row(
                      children: [
                        Text('Введите вариант ответа...'),
                      ],
                    ),
                  ),
                ),
              AnswerType.file => Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Container(
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
                    child: const Row(
                      spacing: 12,
                      children: [
                        Icon(
                          Icons.attach_file,
                          size: 20,
                        ),
                        Text('Прикрепите файл с ответом...'),
                      ],
                    ),
                  ),
                ),
              AnswerType.variants => Flexible(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: task.answerVariants
                              ?.map(
                                (e) => Container(
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
                                      Text(e),
                                    ],
                                  ),
                                ),
                              )
                              .toList() ??
                          [],
                    ),
                  ),
                ),
            },
          ],
        ),
      );
}
