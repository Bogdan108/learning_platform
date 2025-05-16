import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:learning_platform/src/core/widget/custom_elevated_button.dart';
import 'package:learning_platform/src/feature/task/model/answer_type.dart';
import 'package:learning_platform/src/feature/task/model/question_type.dart';

class CreateTaskDialog extends StatefulWidget {
  final void Function({
    required QuestionType questionType,
    required AnswerType answerType,
    String? questionText,
    List<String>? answerVariants,
    Uint8List? questionFile,
    String? filename,
  }) onSave;

  const CreateTaskDialog({
    required this.onSave,
    super.key,
  });

  Future<bool?> show(BuildContext context) => showDialog<bool>(
        context: context,
        barrierDismissible: false,
        builder: (_) => this,
      );

  @override
  State<CreateTaskDialog> createState() => _CreateTaskDialogState();
}

class _CreateTaskDialogState extends State<CreateTaskDialog> {
  QuestionType _questionType = QuestionType.text;
  AnswerType _answerType = AnswerType.text;

  final TextEditingController _questionTextController = TextEditingController();
  PlatformFile? _questionFile;

  final List<TextEditingController> _answersControllers = [];

  @override
  void dispose() {
    _questionTextController.dispose();
    super.dispose();
  }

  Future<void> _pickQuestionFile() async {
    final result = await FilePicker.platform.pickFiles(withData: true);
    if (result != null && result.files.single.path != null) {
      setState(() {
        _questionFile = result.files.first;
      });
    }
  }

  @override
  Widget build(BuildContext context) => Dialog(
        insetPadding: const EdgeInsets.symmetric(horizontal: 40),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        backgroundColor: Colors.white,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Создание задачи',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 16),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Тип вопроса',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: DropdownButton<QuestionType>(
                    value: _questionType,
                    isExpanded: true,
                    underline: const SizedBox(),
                    items: const [
                      DropdownMenuItem(
                        value: QuestionType.text,
                        child: Text('Текст'),
                      ),
                      DropdownMenuItem(
                        value: QuestionType.file,
                        child: Text('Файл'),
                      ),
                    ],
                    onChanged: (v) {
                      if (v != null) {
                        setState(() {
                          _questionType = v;
                          _questionTextController.clear();
                          _questionFile = null;
                        });
                      }
                    },
                  ),
                ),
                const SizedBox(height: 12),
                if (_questionType == QuestionType.text) ...[
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Вопрос',
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                    ),
                  ),
                  const SizedBox(height: 4),
                  TextField(
                    controller: _questionTextController,
                    maxLines: 3,
                    decoration: InputDecoration(
                      hintText: 'Введите текст вопроса',
                      filled: true,
                      fillColor: Colors.grey.shade200,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 12,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ] else ...[
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Файл вопроса',
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                    ),
                  ),
                  const SizedBox(height: 4),
                  GestureDetector(
                    onTap: _pickQuestionFile,
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 14,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        _questionFile?.name ?? 'Выберите файл',
                        style: TextStyle(
                          color: _questionFile == null
                              ? Colors.grey[600]
                              : Colors.black,
                        ),
                      ),
                    ),
                  ),
                ],
                const SizedBox(height: 24),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Тип ответа',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: DropdownButton<AnswerType>(
                    value: _answerType,
                    isExpanded: true,
                    underline: const SizedBox(),
                    items: const [
                      DropdownMenuItem(
                        value: AnswerType.text,
                        child: Text('Текст'),
                      ),
                      DropdownMenuItem(
                        value: AnswerType.file,
                        child: Text('Файл'),
                      ),
                      DropdownMenuItem(
                        value: AnswerType.variants,
                        child: Text('Варианты'),
                      ),
                    ],
                    onChanged: (v) {
                      if (v != null) {
                        setState(() {
                          _answerType = v;
                        });
                      }
                    },
                  ),
                ),
                const SizedBox(height: 12),
                if (_answerType == AnswerType.variants) ...[
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Варианты ответов',
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                    ),
                  ),
                  const SizedBox(height: 4),
                  for (final answer in _answersControllers) ...[
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: TextField(
                        controller: answer,
                        decoration: InputDecoration(
                          hintText: 'Введите вариант ответа',
                          filled: true,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 12,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),
                  ],
                  const SizedBox(height: 4),
                  CustomElevatedButton(
                    onPressed: () {
                      setState(() {
                        _answersControllers.add(TextEditingController());
                      });
                    },
                    title: 'Добавить вариант ответа',
                  ),
                ],
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () => Navigator.of(context).pop(false),
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          'Отмена',
                          style: TextStyle(fontSize: 17, color: Colors.blue),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          final qText = _questionType == QuestionType.text
                              ? _questionTextController.text.trim()
                              : null;

                          widget.onSave(
                            questionType: _questionType,
                            questionText: qText,
                            answerType: _answerType,
                            answerVariants:
                                _answersControllers.map((e) => e.text).toList(),
                            questionFile: _questionFile?.bytes,
                            filename: _questionFile?.name,
                          );
                          context.pop();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          elevation: 0,
                        ),
                        child: const Text(
                          'Сохранить',
                          style: TextStyle(fontSize: 17, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
}
