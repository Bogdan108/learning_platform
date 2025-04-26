// lib/src/feature/assignment/widget/create_edit_assignment_dialog.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:learning_platform/src/common/widget/custom_elevated_button.dart';
import 'package:learning_platform/src/feature/assignment/model/assignment_request.dart';

typedef OnSave = void Function(AssignmentRequest req);

class CreateEditAssignmentDialog extends StatefulWidget {
  final String title;
  final DateTime? initialStart;
  final DateTime? initialEnd;
  final String initialName;
  final OnSave onSave;

  const CreateEditAssignmentDialog({
    required this.title,
    required this.onSave,
    this.initialName = '',
    this.initialStart,
    this.initialEnd,
    super.key,
  });

  Future<bool?> show(BuildContext ctx) => showDialog<bool>(
        context: ctx,
        barrierDismissible: false,
        builder: (_) => this,
      );

  @override
  State<CreateEditAssignmentDialog> createState() => _State();
}

class _State extends State<CreateEditAssignmentDialog> {
  late final TextEditingController _nameC;
  DateTime? _start;
  DateTime? _end;

  @override
  void initState() {
    super.initState();
    _nameC = TextEditingController(text: widget.initialName);
    _start = widget.initialStart;
    _end = widget.initialEnd;
  }

  Future<void> _pickDate(BuildContext ctx, bool isStart) async {
    final now = DateTime.now();
    final dt = await showDatePicker(
      context: ctx,
      initialDate: isStart ? (_start ?? now) : (_end ?? now),
      firstDate: DateTime(now.year - 1),
      lastDate: DateTime(now.year + 5),
    );
    if (dt != null) setState(() => isStart ? _start = dt : _end = dt);
  }

  @override
  Widget build(BuildContext c) => Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        insetPadding: const EdgeInsets.symmetric(horizontal: 40),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                widget.title,
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _nameC,
                decoration: InputDecoration(
                  hintText: 'Название',
                  filled: true,
                  fillColor: Colors.grey.shade200,
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              GestureDetector(
                onTap: () => _pickDate(c, true),
                child: AbsorbPointer(
                  child: TextField(
                    decoration: InputDecoration(
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
                      hintText: _start != null
                          ? DateFormat.yMd().format(_start!)
                          : 'Дата открытия',
                      suffixIcon: const Icon(Icons.calendar_month_sharp),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: () => _pickDate(c, false),
                child: AbsorbPointer(
                  child: TextField(
                    decoration: InputDecoration(
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
                      hintText: _end != null
                          ? DateFormat.yMd().format(_end!)
                          : 'Дата закрытия',
                      suffixIcon: const Icon(Icons.calendar_month_sharp),
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
                    child: CustomElevatedButton(
                      onPressed: () {
                        final name = _nameC.text.trim();
                        if (name.isNotEmpty && _start != null) {
                          widget.onSave(
                            AssignmentRequest(
                              name: name,
                              startedAt: _start!,
                              endedAt: _end,
                            ),
                          );
                          Navigator.pop(c, true);
                        }
                      },
                      title: 'Сохранить',
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
}
