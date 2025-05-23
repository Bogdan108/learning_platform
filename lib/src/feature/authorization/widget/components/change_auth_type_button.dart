import 'package:flutter/material.dart';

class ChangeAuthTypeButton extends StatelessWidget {
  const ChangeAuthTypeButton({
    required this.title,
    required this.subTitle,
    required this.onPressed,
    super.key,
  });

  final String title;
  final String subTitle;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
            ),
          ),
          const SizedBox(width: 5),
          TextButton(
            onPressed: onPressed,
            child: Text(
              subTitle,
              style: const TextStyle(
                color: Colors.lightBlue,
                fontSize: 16,
              ),
            ),
          ),
        ],
      );
}
