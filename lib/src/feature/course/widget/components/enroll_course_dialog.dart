import 'package:flutter/material.dart';

class EnrollCourseDialog extends StatefulWidget {
  final void Function(
    String id,
  ) onEnrollCallBack;

  const EnrollCourseDialog({
    required this.onEnrollCallBack,
    super.key,
  });

  Future<bool?> show(BuildContext context) => showDialog<bool>(
        context: context,
        barrierDismissible: false,
        builder: (context) => this,
      );

  @override
  State<EnrollCourseDialog> createState() => _CreateCourseDialogState();
}

class _CreateCourseDialogState extends State<EnrollCourseDialog> {
  late final TextEditingController idController;

  @override
  void initState() {
    super.initState();
    idController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) => Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        insetPadding: const EdgeInsets.symmetric(horizontal: 40),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Добавление курса',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Идентификатор курса',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              TextField(
                controller: idController,
                decoration: InputDecoration(
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
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () {
                        Navigator.of(context).pop(false);
                      },
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'Отмена',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w400,
                          color: Colors.blue,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        final name = idController.text.trim();
                        if (name.isNotEmpty) {
                          widget.onEnrollCallBack(name);
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
                        'Записаться',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
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
