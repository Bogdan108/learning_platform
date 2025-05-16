import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_platform/src/core/utils/set_state_mixin.dart';
import 'package:learning_platform/src/feature/course/course_details/bloc/course_event.dart';
import 'package:learning_platform/src/feature/course/course_details/bloc/course_state.dart';
import 'package:learning_platform/src/feature/course/course_details/data/repository/course_repository.dart';
import 'package:learning_platform/src/feature/course/course_details/data/repository/i_course_repository.dart';
import 'package:learning_platform/src/feature/course/course_details/model/course_additions.dart';

class CourseBloc extends Bloc<CourseEvent, CourseState> with SetStateMixin {
  final ICourseRepository _courseRepository;

  CourseBloc({
    required CourseRepository courseRepository,
    CourseState? initialState,
  })  : _courseRepository = courseRepository,
        super(
          initialState ??
              CourseState.idle(
                additions: CourseAdditions.empty(),
                students: const [],
              ),
        ) {
    on<CourseEvent>(
      (event, emit) => switch (event) {
        CourseEvent$FetchCourseAddition() => _fetchCourseAdditions(event, emit),
        CourseEvent$DeleteAddition() => _deleteAddition(event, emit),
        CourseEvent$AddLinkAddition() => _addLinkAddition(event, emit),
        CourseEvent$UploadMaterial() => _onUploadMaterial(event, emit),
        CourseEvent$LeaveCourse() => _leaveCourse(event, emit),
      },
    );
  }

  Future<void> _fetchCourseAdditions(
    CourseEvent$FetchCourseAddition event,
    Emitter<CourseState> emit,
  ) async {
    emit(
      CourseState.loading(
        additions: state.additions,
        students: state.students,
      ),
    );

    try {
      final additions = await _courseRepository.getCourseAdditions(
        event.courseId,
      );

      if (!event.isStudent) {
        final students = await _courseRepository.getCourseStudents(
          event.courseId,
        );

        emit(
          CourseState.idle(additions: additions, students: students),
        );
        return;
      }
      emit(
        CourseState.idle(
          additions: additions,
          students: [],
        ),
      );
    } on Object catch (e, st) {
      emit(
        CourseState.error(
          additions: state.additions,
          students: state.students,
          error: 'Ошибка загрузки материалов',
          event: event,
        ),
      );
      onError(e, st);
    }
  }

  Future<void> _deleteAddition(
    CourseEvent$DeleteAddition event,
    Emitter<CourseState> emit,
  ) async {
    emit(
      CourseState.loading(
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
        CourseState.idle(additions: additions, students: students),
      );
    } on Object catch (e, st) {
      emit(
        CourseState.error(
          additions: state.additions,
          students: state.students,
          error: 'Ошибка удаления материала',
          event: event,
        ),
      );
      onError(e, st);
    }
  }

  Future<void> _addLinkAddition(
    CourseEvent$AddLinkAddition event,
    Emitter<CourseState> emit,
  ) async {
    emit(
      CourseState.loading(
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
        CourseState.idle(additions: additions, students: students),
      );
    } on Object catch (e, st) {
      emit(
        CourseState.error(
          additions: state.additions,
          students: state.students,
          error: 'Ошибка добавления ссылки',
          event: event,
        ),
      );
      onError(e, st);
    }
  }

  Future<void> _onUploadMaterial(
    CourseEvent$UploadMaterial event,
    Emitter<CourseState> emit,
  ) async {
    emit(
      CourseState.loading(
        additions: state.additions,
        students: state.students,
      ),
    );

    try {
      await _courseRepository.uploadMaterial(
        event.courseId,
        event.file,
        event.fileName,
      );

      final additions = await _courseRepository.getCourseAdditions(
        event.courseId,
      );
      emit(
        CourseState.idle(
          additions: additions,
          students: state.students,
        ),
      );
    } catch (e, st) {
      emit(
        CourseState.error(
          additions: state.additions,
          students: state.students,
          error: 'Ошибка добавления файла',
          event: event,
        ),
      );
      onError(e, st);
    }
  }

  Future<void> _leaveCourse(
    CourseEvent$LeaveCourse event,
    Emitter<CourseState> emit,
  ) async {
    emit(
      CourseState.loading(
        additions: state.additions,
        students: state.students,
      ),
    );

    try {
      await _courseRepository.leaveCourse(
        event.courseId,
      );

      emit(
        CourseState.idle(
          additions: state.additions,
          students: state.students,
        ),
      );
    } catch (e, st) {
      emit(
        CourseState.error(
          additions: state.additions,
          students: state.students,
          error: 'Ошибка выхода с курса',
          event: event,
        ),
      );
      onError(e, st);
    }
  }
}
