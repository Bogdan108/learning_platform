import 'package:flutter/material.dart';
import 'package:learning_platform/src/feature/assignment/model/assignment.dart';

class AssignmentTile extends StatelessWidget {
  final Assignment assignment;
  final VoidCallback onTap;
  final Widget? trailing;
  final Widget? subtitle;

  const AssignmentTile({
    required this.assignment,
    required this.onTap,
    this.trailing,
    this.subtitle,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: const Color(
          0xFFE2F2FF,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        title: Text(
          assignment.name,
          style: const TextStyle(fontSize: 16),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Column(
            spacing: 4.0,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (assignment.status != null)
                Text(
                  assignment.status!.statusText,
                  style: TextStyle(
                    color: assignment.status!.statusColor,
                  ),
                ),
              Text(
                'Дедлайн: ${assignment.endedAt != null ? assignment.endedAt!.toLocal().toString().split(' ')[0] : '—'}',
                style: const TextStyle(color: Color(0xFFC1121F)),
              ),
            ],
          ),
        ),
        trailing: trailing,
        onTap: onTap,
      ),
    );
  }
}
