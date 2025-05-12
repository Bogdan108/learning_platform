import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:learning_platform/src/feature/task/bloc/tasks_bloc/tasks_bloc_event.dart';
import 'package:learning_platform/src/feature/task/model/task.dart';

part 'tasks_bloc_state.freezed.dart';

@freezed
sealed class TasksBlocState with _$TasksBlocState {
  const factory TasksBlocState.idle({
    required List<Task> tasks,
  }) = Idle;

  const factory TasksBlocState.loading({
    required List<Task> tasks,
  }) = Loading;

  const factory TasksBlocState.error({
    required String error,
    required List<Task> tasks,
    TasksBlocEvent? event,
  }) = Error;
}
