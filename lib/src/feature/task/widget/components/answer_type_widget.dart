import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:learning_platform/src/feature/task/model/answer_type.dart';
import 'package:learning_platform/src/feature/task/model/task.dart';

class AnswerTypeWidget extends StatelessWidget {
  final Task task;
  final String? fileName;
  final String? initialText;
  final int? varinalAnswerIndex;
  final void Function(String text) onTextAnswer;
  final VoidCallback onFileChangeAnswer;
  final void Function(int index) onVariantChangeAnswer;

  const AnswerTypeWidget({
    required this.task,
    required this.onTextAnswer,
    required this.onFileChangeAnswer,
    required this.onVariantChangeAnswer,
    this.fileName,
    this.varinalAnswerIndex,
    this.initialText,
    super.key,
  });

  @override
  Widget build(BuildContext context) => switch (task.answerType) {
        AnswerType.text => Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
            ),
            margin: const EdgeInsets.only(bottom: 4),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: Colors.blue,
                width: 2,
              ),
            ),
            child: TextField(
              decoration: const InputDecoration(
                hintText: 'Введите ответ',
                border: InputBorder.none,
              ),
              controller: TextEditingController(text: initialText),
              onChanged: onTextAnswer,
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
              children: [
                const Icon(Icons.attach_file),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    fileName ?? 'Прикрепить файл',
                  ),
                ),
                GestureDetector(
                  onTap: onFileChangeAnswer,
                  child: const Text('Выбрать'),
                ),
              ],
            ),
          ),
        AnswerType.variants => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: task.answerVariants?.mapIndexed(
                  (index, e) {
                    final isSelected = varinalAnswerIndex == index;

                    return GestureDetector(
                      onTap: () {
                        if (!isSelected) {
                          onVariantChangeAnswer(index);
                        }
                      },
                      child: Container(
                        margin: const EdgeInsets.only(
                          bottom: 4,
                        ),
                        padding: const EdgeInsets.all(
                          10,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                            10,
                          ),
                          color: isSelected ? Colors.blue : Colors.white,
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
                    );
                  },
                ).toList() ??
                [],
          ),
      };
}
