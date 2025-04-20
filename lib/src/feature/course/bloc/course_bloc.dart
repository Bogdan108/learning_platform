import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_platform/src/common/utils/set_state_mixin.dart';
import 'package:learning_platform/src/feature/course/bloc/course_bloc_event.dart';
import 'package:learning_platform/src/feature/course/bloc/course_bloc_state.dart';
import 'package:learning_platform/src/feature/course/data/repository/i_course_repository.dart';

class CourseBloc extends Bloc<CourseBlocEvent, CourseBlocState>
    with SetStateMixin {
  final ICourseRepository _courseRepository;

  CourseBloc(
    super.initialState, {
    required ICourseRepository courseRepository,
  }) : _courseRepository = courseRepository {
    on<CourseBlocEvent>(
      (event, emit) => switch (event) {
        FetchCourseAdditionEvent() => _fetchCourseAdditions(event, emit),
        DeleteAdditionEvent() => _deleteAddition(event, emit),
        AddLinkAdditionEvent() => _addLinkAddition(event, emit),
      },
    );
  }

  Future<void> _fetchCourseAdditions(
    FetchCourseAdditionEvent event,
    Emitter<CourseBlocState> emit,
  ) async {
    emit(
      CourseBlocState.loading(additions: state.additions),
    );

    try {
      final additions = await _courseRepository.getCourseAdditions(
        event.organizationId,
        event.courseId,
      );
      emit(
        CourseBlocState.idle(
          additions: additions,
        ),
      );
    } on Object catch (e, st) {
      emit(
        CourseBlocState.error(
          additions: state.additions,
          error: e.toString(),
        ),
      );
      onError(e, st);
    }
  }

  Future<void> _deleteAddition(
    DeleteAdditionEvent event,
    Emitter<CourseBlocState> emit,
  ) async {
    emit(
      CourseBlocState.loading(
        additions: state.additions,
      ),
    );

    try {
      await _courseRepository.deleteAddition(
        event.organizationId,
        event.courseId,
        event.additionType,
        event.additionId,
      );
      final additions = await _courseRepository.getCourseAdditions(
        event.organizationId,
        event.courseId,
      );
      emit(
        CourseBlocState.idle(
          additions: additions,
        ),
      );
    } on Object catch (e, st) {
      emit(
        CourseBlocState.error(
          additions: state.additions,
          error: e.toString(),
        ),
      );
      onError(e, st);
    }
  }

  Future<void> _addLinkAddition(
    AddLinkAdditionEvent event,
    Emitter<CourseBlocState> emit,
  ) async {
    emit(
      CourseBlocState.loading(
        additions: state.additions,
      ),
    );

    try {
      await _courseRepository.addLinkAddition(
        event.organizationId,
        event.courseId,
        event.link,
      );
      final additions = await _courseRepository.getCourseAdditions(
        event.organizationId,
        event.courseId,
      );
      emit(
        CourseBlocState.idle(
          additions: additions,
        ),
      );
    } on Object catch (e, st) {
      emit(
        CourseBlocState.error(
          additions: state.additions,
          error: e.toString(),
        ),
      );
      onError(e, st);
    }
  }
}
