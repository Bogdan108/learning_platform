import 'package:flutter/material.dart';

/// Статусы выполнения задания
enum AssignmentStatus {
  /// Задание нужно выполнить
  pending,

  /// Задание в проверке (ответ отправлен, ожидает оценки)
  inReview,

  /// Задание оценено
  graded;

  Color get statusColor => switch (this) {
        AssignmentStatus.pending => Colors.orange,
        AssignmentStatus.inReview => Colors.red,
        AssignmentStatus.graded => Colors.green,
      };

  String get statusText => switch (this) {
        AssignmentStatus.pending => 'Нужно пройти',
        AssignmentStatus.inReview => 'В проверке',
        AssignmentStatus.graded => 'Оценено',
      };
}
