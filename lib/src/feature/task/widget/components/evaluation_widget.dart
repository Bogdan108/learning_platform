import 'package:flutter/material.dart';

class EvaluationWidget extends StatelessWidget {
  final int score;
  final String? comment;

  const EvaluationWidget({
    required this.score,
    required this.comment,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    const headerTextStyle = TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.w600,
      color: Colors.black,
    );
    const scoreTextStyle = TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.w600,
      color: Color(0xFF007AFF),
    );
    const labelTextStyle = TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w500,
      color: Colors.black,
    );
    const commentTextStyle = TextStyle(
      fontSize: 16,
      color: Colors.white,
    );
    const commentBackground = Color(0xFF007AFF);

    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
        border: Border.all(
          color: Colors.blue,
          width: 2,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                const Text('Оценка', style: headerTextStyle),
                const Spacer(),
                Text(score.toString(), style: scoreTextStyle),
              ],
            ),
            const SizedBox(height: 8),
            const Text('Комментарий', style: labelTextStyle),
            const SizedBox(height: 8),
            if (comment != null)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: commentBackground,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  comment!,
                  style: commentTextStyle,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
