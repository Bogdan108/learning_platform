import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_platform/src/core/utils/set_state_mixin.dart';
import 'package:learning_platform/src/feature/task/bloc/answer_tasks_bloc/answer_tasks_event.dart';
import 'package:learning_platform/src/feature/task/bloc/answer_tasks_bloc/answer_tasks_state.dart';
import 'package:learning_platform/src/feature/task/data/repository/i_tasks_repository.dart';

class AnswerTasksBloc extends Bloc<AnswerTasksEvent, AnswerTasksState> with SetStateMixin {
  final ITasksRepository _tasksRepository;

  AnswerTasksBloc({required ITasksRepository tasksRepository})
      : _tasksRepository = tasksRepository,
        super(const AnswerTasksState.idle(tasks: [])) {
    on<AnswerTasksEvent>(
      (event, emit) => switch (event) {
        AnswerTasksEvent$FetchTasks() => _onFetch(event, emit),
        AnswerTasksEvent$AnswerText() => _onAnswerText(event, emit),
        AnswerTasksEvent$AnswerFile() => _onAnswerFile(event, emit),
      },
    );
  }

  Future<void> _onFetch(
    AnswerTasksEvent$FetchTasks event,
    Emitter<AnswerTasksState> emit,
  ) async {
    emit(AnswerTasksState.loading(tasks: state.tasks));
    try {
      final list = await _tasksRepository.listTasks(event.assignmentId);
      emit(
        AnswerTasksState.idle(
          tasks: list,
        ),
      );
    } catch (err, st) {
      emit(
        AnswerTasksState.error(
          error: 'Ошибка при загрузке списка заданий',
          tasks: state.tasks,
          event: event,
        ),
      );
      onError(err, st);
    }
  }

  Future<void> _onAnswerText(
    AnswerTasksEvent$AnswerText event,
    Emitter<AnswerTasksState> emit,
  ) async {
    try {
      emit(AnswerTasksState.loading(tasks: state.tasks));

      await _tasksRepository.answerText(
        assignmentId: event.assignmentId,
        taskId: event.taskId,
        text: event.text,
      );

      emit(AnswerTasksState.idle(
        tasks: state.tasks,
        event: event,
      ));
    } catch (err) {
      emit(
        AnswerTasksState.error(
          error: 'Ошибка при отправке текста ответа',
          tasks: state.tasks,
          event: event,
        ),
      );
    }
  }

  Future<void> _onAnswerFile(
    AnswerTasksEvent$AnswerFile event,
    Emitter<AnswerTasksState> emit,
  ) async {
    try {
      emit(AnswerTasksState.loading(tasks: state.tasks));

      await _tasksRepository.answerFile(
        assignmentId: event.assignmentId,
        taskId: event.taskId,
        file: event.file,
        fileName: event.fileName,
      );
      emit(
        AnswerTasksState.idle(
          tasks: state.tasks,
          event: event,
        ),
      );
    } catch (err) {
      emit(
        AnswerTasksState.error(
          error: 'Ошибка при отправке файла с ответом',
          tasks: state.tasks,
          event: event,
        ),
      );
    }
  }
}
