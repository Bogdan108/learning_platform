import 'package:flutter/material.dart';
import 'package:learning_platform/src/core/widget/custom_elevated_button.dart';

class FinishAnswerCard extends StatelessWidget {
  final String title;
  final VoidCallback onViewAnswers;

  const FinishAnswerCard({
    required this.onViewAnswers,
    this.title = 'Работа выполнена',
    super.key,
  });

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: const Color(0xFFE3F2FD),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 16),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 16),
              Icon(
                Icons.celebration,
                size: 48,
                color: Colors.blue.shade700,
              ),
              const SizedBox(height: 24),
              CustomElevatedButton(
                onPressed: onViewAnswers,
                title: 'Посмотреть ответы',
              ),
            ],
          ),
        ),
      );
}
