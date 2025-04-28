import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class CreateTaskDialog extends StatefulWidget {
  final void Function({
    required String questionType,
    required String answerType,
    String? questionText,
    List<String>? answerVariants,
    File? questionFile,
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
  String _questionType = 'text';
  final TextEditingController _questionTextController = TextEditingController();
  File? _questionFile;

  String _answerType = 'text';
  final TextEditingController _variantsController = TextEditingController();

  @override
  void dispose() {
    _questionTextController.dispose();
    _variantsController.dispose();
    super.dispose();
  }

  Future<void> _pickQuestionFile() async {
    final result = await FilePicker.platform.pickFiles();
    if (result != null && result.files.single.path != null) {
      setState(() {
        _questionFile = File(result.files.single.path!);
      });
    }
  }

  @override
  Widget build(BuildContext context) => Dialog(
        insetPadding: const EdgeInsets.symmetric(horizontal: 40),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        backgroundColor: Colors.white,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Создание задачи',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 16),

                // Question type
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
                  child: DropdownButton<String>(
                    value: _questionType,
                    isExpanded: true,
                    underline: const SizedBox(),
                    items: const [
                      DropdownMenuItem(value: 'text', child: Text('Текст')),
                      DropdownMenuItem(value: 'file', child: Text('Файл')),
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

                // Question content
                if (_questionType == 'text') ...[
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
                        _questionFile?.path
                                .split(Platform.pathSeparator)
                                .last ??
                            'Выберите файл',
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

                // Answer type
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
                  child: DropdownButton<String>(
                    value: _answerType,
                    isExpanded: true,
                    underline: const SizedBox(),
                    items: const [
                      DropdownMenuItem(value: 'text', child: Text('Текст')),
                      DropdownMenuItem(value: 'file', child: Text('Файл')),
                      DropdownMenuItem(
                        value: 'variants',
                        child: Text('Варианты'),
                      ),
                    ],
                    onChanged: (v) {
                      if (v != null) {
                        setState(() {
                          _answerType = v;
                          _variantsController.clear();
                        });
                      }
                    },
                  ),
                ),

                const SizedBox(height: 12),

                // Variants input
                if (_answerType == 'variants') ...[
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Варианты (через запятую)',
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                    ),
                  ),
                  const SizedBox(height: 4),
                  TextField(
                    controller: _variantsController,
                    decoration: InputDecoration(
                      hintText: 'Например: Вариант1, Вариант2, Вариант3',
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
                          final qText = _questionType == 'text'
                              ? _questionTextController.text.trim()
                              : null;
                          if (_questionType == 'text' &&
                              (qText == null || qText.isEmpty)) {
                            return; // require question text
                          }
                          if (_questionType == 'file' &&
                              _questionFile == null) {
                            return; // require file
                          }
                          final variants = _answerType == 'variants'
                              ? _variantsController.text
                                  .split(',')
                                  .map((s) => s.trim())
                                  .where((s) => s.isNotEmpty)
                                  .toList()
                              : null;
                          if (_answerType == 'variants' &&
                              (variants == null || variants.isEmpty)) {
                            return;
                          }

                          widget.onSave(
                            questionType: _questionType,
                            questionText: qText,
                            answerType: _answerType,
                            answerVariants: variants,
                            questionFile: _questionFile,
                          );
                          Navigator.of(context).pop(true);
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
