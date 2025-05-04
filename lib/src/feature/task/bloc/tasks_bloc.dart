import 'dart:developer';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_platform/src/core/utils/set_state_mixin.dart';
import 'package:learning_platform/src/feature/task/bloc/tasks_bloc_event.dart';
import 'package:learning_platform/src/feature/task/bloc/tasks_bloc_state.dart';
import 'package:learning_platform/src/feature/task/data/repository/i_tasks_repository.dart';

class TasksBloc extends Bloc<TasksBlocEvent, TasksBlocState>
    with SetStateMixin {
  final ITasksRepository _repo;

  TasksBloc({required ITasksRepository repo})
      : _repo = repo,
        super(const TasksBlocState.idle(tasks: [])) {
    on<TasksBlocEvent>(
      (event, emit) => switch (event) {
        FetchTasks() => _onFetch(event, emit),
        CreateTask() => _onCreate(event, emit),
        DeleteTask() => _onDelete(event, emit),
        AddFileToTask() => _onAddFile(event, emit),
        AnswerText() => _onAnswerText(event, emit),
        AnswerFile() => _onAnswerFile(event, emit),
        EvaluateTask() => _onEvaluate(event, emit),
        FeedbackTask() => _onFeedback(event, emit),
      },
    );
  }

  Future<void> _onFetch(
    FetchTasks e,
    Emitter<TasksBlocState> emit,
  ) async {
    emit(TasksBlocState.loading(tasks: state.tasks));
    try {
      final list = await _repo.listTasks(e.assignmentId);
      emit(TasksBlocState.idle(tasks: list));
    } catch (err, st) {
      emit(TasksBlocState.error(error: err.toString(), tasks: state.tasks));
      onError(err, st);
    }
  }

  Future<void> _onCreate(
    CreateTask e,
    Emitter<TasksBlocState> emit,
  ) async {
    emit(TasksBlocState.loading(tasks: state.tasks));
    try {
      final taskId = await _repo.createTask(e.assignmentId, e.req);

      final taskFile = e.file;
      if (taskFile != null) await _repo.addQuestionFile(taskId, taskFile);

      final list = await _repo.listTasks(e.assignmentId);
      emit(TasksBlocState.idle(tasks: list));
    } catch (err, st) {
      emit(TasksBlocState.error(error: err.toString(), tasks: state.tasks));
      onError(err, st);
    }
  }

  Future<void> _onDelete(
    DeleteTask e,
    Emitter<TasksBlocState> emit,
  ) async {
    emit(TasksBlocState.loading(tasks: state.tasks));
    try {
      await _repo.deleteTask(e.taskId);
      final list = await _repo.listTasks(e.assignmentId);
      emit(TasksBlocState.idle(tasks: list));
    } catch (err, st) {
      emit(TasksBlocState.error(error: err.toString(), tasks: state.tasks));
      onError(err, st);
    }
  }

  Future<void> _onAddFile(
    AddFileToTask e,
    Emitter<TasksBlocState> emit,
  ) async {
    emit(TasksBlocState.loading(tasks: state.tasks));
    try {
      await _repo.addQuestionFile(e.taskId, e.file);
      emit(TasksBlocState.idle(tasks: state.tasks));
    } catch (err, st) {
      emit(TasksBlocState.error(error: err.toString(), tasks: state.tasks));
      onError(err, st);
    }
  }

  Future<void> _onAnswerText(
    AnswerText e,
    Emitter<TasksBlocState> emit,
  ) async {
    try {
      await _repo.answerText(e.assignmentId, e.taskId, e.text);
    } catch (err) {
      log('AnswerText failed: $err');
    }
  }

  Future<void> _onAnswerFile(
    AnswerFile e,
    Emitter<TasksBlocState> emit,
  ) async {
    try {
      await _repo.answerFile(e.assignmentId, e.taskId, e.file);
    } catch (err) {
      log('AnswerFile failed: $err');
    }
  }

  Future<void> _onEvaluate(
    EvaluateTask e,
    Emitter<TasksBlocState> emit,
  ) async {
    try {
      await _repo.evaluateTask(e.assignmentId, e.taskId, e.userId, e.score);
    } catch (err) {
      log('EvaluateTask failed: $err');
    }
  }

  Future<void> _onFeedback(
    FeedbackTask e,
    Emitter<TasksBlocState> emit,
  ) async {
    try {
      await _repo.feedbackTask(e.assignmentId, e.taskId, e.userId, e.feedback);
    } catch (err) {
      log('FeedbackTask failed: $err');
    }
  }
}
