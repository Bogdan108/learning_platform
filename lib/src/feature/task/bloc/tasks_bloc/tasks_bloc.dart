import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_platform/src/core/utils/set_state_mixin.dart';
import 'package:learning_platform/src/feature/task/bloc/tasks_bloc/tasks_bloc_event.dart';
import 'package:learning_platform/src/feature/task/bloc/tasks_bloc/tasks_bloc_state.dart';
import 'package:learning_platform/src/feature/task/data/repository/i_tasks_repository.dart';

class TasksBloc extends Bloc<TasksBlocEvent, TasksBlocState>
    with SetStateMixin {
  final ITasksRepository _tasksRepository;

  TasksBloc({required ITasksRepository tasksRepository})
      : _tasksRepository = tasksRepository,
        super(const TasksBlocState.idle(tasks: [])) {
    on<TasksBlocEvent>(
      (event, emit) => switch (event) {
        FetchTasks() => _onFetch(event, emit),
        CreateTask() => _onCreate(event, emit),
        DeleteTask() => _onDelete(event, emit),
        AddFileToTask() => _onAddFile(event, emit),
        AnswerText() => _onAnswerText(event, emit),
        AnswerFile() => _onAnswerFile(event, emit),
      },
    );
  }

  Future<void> _onFetch(
    FetchTasks e,
    Emitter<TasksBlocState> emit,
  ) async {
    emit(TasksBlocState.loading(tasks: state.tasks));
    try {
      final list = await _tasksRepository.listTasks(e.assignmentId);
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
      final taskId = await _tasksRepository.createTask(e.assignmentId, e.req);

      final taskFile = e.file;
      if (taskFile != null) {
        await _tasksRepository.addQuestionFile(taskId, taskFile);
      }

      final list = await _tasksRepository.listTasks(e.assignmentId);
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
      await _tasksRepository.deleteTask(e.taskId);
      final list = await _tasksRepository.listTasks(e.assignmentId);
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
      await _tasksRepository.addQuestionFile(e.taskId, e.file);
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
      await _tasksRepository.answerText(e.assignmentId, e.taskId, e.text);
    } catch (err) {
      emit(
        TasksBlocState.error(
          error: 'Ошибка при отправке ответа',
          tasks: state.tasks,
        ),
      );
    }
  }

  Future<void> _onAnswerFile(
    AnswerFile e,
    Emitter<TasksBlocState> emit,
  ) async {
    try {
      await _tasksRepository.answerFile(e.assignmentId, e.taskId, e.file);
    } catch (err) {
      emit(
        TasksBlocState.error(
          error: 'Ошибка при отправке ответа',
          tasks: state.tasks,
        ),
      );
    }
  }
}
