import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_platform/src/common/utils/set_state_mixin.dart';
import 'package:learning_platform/src/feature/course/bloc/course_bloc_event.dart';
import 'package:learning_platform/src/feature/course/bloc/course_bloc_state.dart';
import 'package:learning_platform/src/feature/course/data/repository/course_repository.dart';
import 'package:learning_platform/src/feature/course/data/repository/i_course_repository.dart';
import 'package:learning_platform/src/feature/course/model/course_additions.dart';

class CourseBloc extends Bloc<CourseBlocEvent, CourseBlocState>
    with SetStateMixin {
  final ICourseRepository _courseRepository;

  CourseBloc({
    required CourseRepository courseRepository,
    CourseBlocState? initialState,
  })  : _courseRepository = courseRepository,
        super(
          initialState ??
              CourseBlocState.idle(
                additions: CourseAdditions.empty(),
                students: const [],
              ),
        ) {
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
      CourseBlocState.loading(
        additions: state.additions,
        students: state.students,
      ),
    );

    try {
      final additions = await _courseRepository.getCourseAdditions(
        event.courseId,
      );
      final students = await _courseRepository.getCourseStudents(
        event.courseId,
      );

      emit(
        CourseBlocState.idle(additions: additions, students: students),
      );
    } on Object catch (e, st) {
      emit(
        CourseBlocState.error(
          additions: state.additions,
          students: state.students,
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
        students: state.students,
      ),
    );

    try {
      await _courseRepository.deleteAddition(
        event.courseId,
        event.additionType,
        event.additionId,
      );
      final additions = await _courseRepository.getCourseAdditions(
        event.courseId,
      );
      final students = await _courseRepository.getCourseStudents(
        event.courseId,
      );

      emit(
        CourseBlocState.idle(additions: additions, students: students),
      );
    } on Object catch (e, st) {
      emit(
        CourseBlocState.error(
          additions: state.additions,
          students: state.students,
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
        students: state.students,
      ),
    );

    try {
      await _courseRepository.addLinkAddition(
        event.courseId,
        event.link,
      );
      final additions = await _courseRepository.getCourseAdditions(
        event.courseId,
      );
      final students = await _courseRepository.getCourseStudents(
        event.courseId,
      );

      emit(
        CourseBlocState.idle(additions: additions, students: students),
      );
    } on Object catch (e, st) {
      emit(
        CourseBlocState.error(
          additions: state.additions,
          students: state.students,
          error: e.toString(),
        ),
      );
      onError(e, st);
    }
  }
}
