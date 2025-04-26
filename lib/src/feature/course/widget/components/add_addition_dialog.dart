import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

enum AdditionType { link, file }

class AddAdditionDialog extends StatefulWidget {
  final void Function({
    required AdditionType type,
    required String link,
  }) onLinkSave;

  final void Function({
    required AdditionType type,
    File? file,
  }) onFileSave;

  const AddAdditionDialog({
    required this.onLinkSave,
    required this.onFileSave,
    super.key,
  });

  Future<bool?> show(BuildContext context) => showDialog<bool>(
        context: context,
        barrierDismissible: false,
        builder: (_) => this,
      );

  @override
  State<AddAdditionDialog> createState() => _AddCourseAdditionDialogState();
}

class _AddCourseAdditionDialogState extends State<AddAdditionDialog> {
  AdditionType _type = AdditionType.link;
  final TextEditingController _linkController = TextEditingController();
  File? _pickedFile;

  @override
  void dispose() {
    _linkController.dispose();
    super.dispose();
  }

  Future<void> _pickFile() async {
    final result = await FilePicker.platform.pickFiles();
    if (result != null && result.files.single.path != null) {
      setState(() {
        _pickedFile = File(result.files.single.path!);
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
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Дополнение материала к курсу',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 16),
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: DropdownButton<AdditionType>(
                  value: _type,
                  isExpanded: true,
                  underline: const SizedBox(),
                  items: const [
                    DropdownMenuItem(
                      value: AdditionType.link,
                      child: Text('Ссылка'),
                    ),
                    DropdownMenuItem(
                      value: AdditionType.file,
                      child: Text('Файл'),
                    ),
                  ],
                  onChanged: (v) {
                    if (v != null) {
                      setState(() {
                        _type = v;
                        _pickedFile = null;
                        _linkController.clear();
                      });
                    }
                  },
                ),
              ),
              const SizedBox(height: 12),
              if (_type == AdditionType.link)
                TextField(
                  controller: _linkController,
                  decoration: InputDecoration(
                    hintText: 'Введите URL',
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
                )
              else
                GestureDetector(
                  onTap: _pickFile,
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 14),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      _pickedFile?.path.split(Platform.pathSeparator).last ??
                          'Выберите файл',
                      style: TextStyle(
                        color: _pickedFile == null
                            ? Colors.grey[600]
                            : Colors.black,
                      ),
                    ),
                  ),
                ),
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
                        if (_type == AdditionType.link &&
                            _linkController.text.trim().isNotEmpty) {
                          widget.onLinkSave(
                            type: _type,
                            link: _linkController.text.trim(),
                          );
                          Navigator.of(context).pop(true);
                        } else if (_type == AdditionType.file &&
                            _pickedFile != null) {
                          widget.onFileSave(type: _type, file: _pickedFile);
                          Navigator.of(context).pop(true);
                        }
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
      );
}
