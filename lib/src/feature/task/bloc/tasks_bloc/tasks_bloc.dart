import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_platform/src/core/utils/set_state_mixin.dart';
import 'package:learning_platform/src/feature/task/bloc/tasks_bloc/tasks_bloc_event.dart';
import 'package:learning_platform/src/feature/task/bloc/tasks_bloc/tasks_bloc_state.dart';
import 'package:learning_platform/src/feature/task/data/repository/i_tasks_repository.dart';

class TasksBloc extends Bloc<TasksBlocEvent, TasksBlocState> with SetStateMixin {
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
    FetchTasks event,
    Emitter<TasksBlocState> emit,
  ) async {
    emit(TasksBlocState.loading(tasks: state.tasks));
    try {
      final list = await _tasksRepository.listTasks(
        event.assignmentId,
      );
      emit(TasksBlocState.idle(tasks: list));
    } catch (err, st) {
      emit(TasksBlocState.error(
        error: 'Ошибка загрузки задач',
        tasks: state.tasks,
        event: event,
      ));
      onError(err, st);
    }
  }

  Future<void> _onCreate(
    CreateTask event,
    Emitter<TasksBlocState> emit,
  ) async {
    emit(TasksBlocState.loading(tasks: state.tasks));
    try {
      final taskId = await _tasksRepository.createTask(
        event.assignmentId,
        event.req,
      );

      final taskFile = event.file;
      if (taskFile != null) {
        await _tasksRepository.addQuestionFile(taskId, taskFile);
      }

      final list = await _tasksRepository.listTasks(
        event.assignmentId,
      );
      emit(TasksBlocState.idle(tasks: list));
    } catch (err, st) {
      emit(TasksBlocState.error(
        error: 'Ошибка создания задачи',
        tasks: state.tasks,
        event: event,
      ));
      onError(err, st);
    }
  }

  Future<void> _onDelete(
    DeleteTask event,
    Emitter<TasksBlocState> emit,
  ) async {
    emit(TasksBlocState.loading(tasks: state.tasks));
    try {
      await _tasksRepository.deleteTask(event.taskId);
      final list = await _tasksRepository.listTasks(
        event.assignmentId,
      );
      emit(TasksBlocState.idle(tasks: list));
    } catch (err, st) {
      emit(TasksBlocState.error(
        error: 'Ошибка удаления задачи',
        tasks: state.tasks,
        event: event,
      ));
      onError(err, st);
    }
  }

  Future<void> _onAddFile(
    AddFileToTask event,
    Emitter<TasksBlocState> emit,
  ) async {
    emit(TasksBlocState.loading(tasks: state.tasks));
    try {
      await _tasksRepository.addQuestionFile(
        event.taskId,
        event.file,
      );
      emit(TasksBlocState.idle(tasks: state.tasks));
    } catch (err, st) {
      emit(TasksBlocState.error(
        error: 'Ошибка прикрепления файла',
        tasks: state.tasks,
        event: event,
      ));
      onError(err, st);
    }
  }

  Future<void> _onAnswerText(
    AnswerText event,
    Emitter<TasksBlocState> emit,
  ) async {
    try {
      await _tasksRepository.answerText(
        event.assignmentId,
        event.taskId,
        event.text,
      );
    } catch (err) {
      emit(
        TasksBlocState.error(
          error: 'Ошибка при отправке ответа',
          tasks: state.tasks,
          event: event,
        ),
      );
    }
  }

  Future<void> _onAnswerFile(
    AnswerFile event,
    Emitter<TasksBlocState> emit,
  ) async {
    try {
      await _tasksRepository.answerFile(
        event.assignmentId,
        event.taskId,
        event.file,
      );
    } catch (err) {
      emit(
        TasksBlocState.error(
          error: 'Ошибка при отправке ответа',
          tasks: state.tasks,
          event: event,
        ),
      );
    }
  }
}
