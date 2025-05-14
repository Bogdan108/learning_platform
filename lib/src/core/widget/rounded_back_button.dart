import 'package:flutter/material.dart';

class RoundedBackButton extends StatelessWidget {
  const RoundedBackButton({super.key, this.onTap});

  final Function? onTap;

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: () => Navigator.pop(context),
        child: Container(
          height: 40,
          width: 40,
          margin: const EdgeInsets.only(right: 1),
          padding: const EdgeInsets.symmetric(
            vertical: 8,
            horizontal: 5,
          ),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            shape: BoxShape.circle,
          ),
          child: const FittedBox(
            fit: BoxFit.cover,
            child: Icon(
              Icons.arrow_back_ios_new_rounded,
            ),
          ),
        ),
      );
}
