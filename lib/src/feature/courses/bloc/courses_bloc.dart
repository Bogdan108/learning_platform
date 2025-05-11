import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_platform/src/core/utils/set_state_mixin.dart';
import 'package:learning_platform/src/feature/courses/bloc/courses_event.dart';
import 'package:learning_platform/src/feature/courses/bloc/courses_state.dart';
import 'package:learning_platform/src/feature/courses/data/repository/courses_repository.dart';
import 'package:learning_platform/src/feature/courses/data/repository/i_courses_repository.dart';
import 'package:learning_platform/src/feature/courses/model/course_request.dart';
import 'package:learning_platform/src/feature/profile/model/user_role.dart';

class CoursesBloc extends Bloc<CoursesEvent, CoursesState> with SetStateMixin {
  final ICoursesRepository _coursesRepository;

  CoursesBloc({
    required CoursesRepository coursesRepository,
    CoursesState? initialState,
  })  : _coursesRepository = coursesRepository,
        super(initialState ?? const CoursesState.idle()) {
    on<CoursesEvent>(
      (event, emit) => switch (event) {
        CoursesEvent$FetchCourses() => _fetchCourses(event, emit),
        CoursesEvent$CreateCourse() => _createCourse(event, emit),
        CoursesEvent$EditCourse() => _editCourse(event, emit),
        CoursesEvent$DeleteCourse() => _deleteCourse(event, emit),
        CoursesEvent$EnrollCourse() => _enrollCourse(event, emit),
      },
    );
  }

  Future<void> _createCourse(
    CoursesEvent$CreateCourse event,
    Emitter<CoursesState> emit,
  ) async {
    emit(
      CoursesState.loading(
        courses: state.courses,
      ),
    );

    try {
      final courseRequest = CourseRequest(name: event.name, description: event.description);
      await _coursesRepository.createCourse(courseRequest);

      final courses = await _coursesRepository.getTeacherCourses(
        '',
      );
      emit(
        CoursesState.idle(
          courses: courses,
        ),
      );
    } on Object catch (_) {
      emit(
        CoursesState.error(
          courses: state.courses,
          error: 'Ошибка создания курса',
          event: event,
        ),
      );
    }
  }

  Future<void> _editCourse(
    CoursesEvent$EditCourse event,
    Emitter<CoursesState> emit,
  ) async {
    emit(
      CoursesState.loading(
        courses: state.courses,
      ),
    );

    try {
      final courseRequest = CourseRequest(name: event.name, description: event.description);
      await _coursesRepository.editCourse(
        event.courseId,
        courseRequest,
      );

      final courses = await _coursesRepository.getTeacherCourses(
        '',
      );
      emit(
        CoursesState.idle(
          courses: courses,
        ),
      );
    } on Object catch (_) {
      emit(
        CoursesState.error(
          courses: state.courses,
          error: 'Ошибка изменения курса',
          event: event,
        ),
      );
    }
  }

  Future<void> _deleteCourse(
    CoursesEvent$DeleteCourse event,
    Emitter<CoursesState> emit,
  ) async {
    emit(
      CoursesState.loading(
        courses: state.courses,
      ),
    );

    try {
      await _coursesRepository.deleteCourse(
        event.courseId,
      );
      final courses = await _coursesRepository.getTeacherCourses(
        '',
      );
      emit(
        CoursesState.idle(
          courses: courses,
        ),
      );
    } on Object catch (_) {
      emit(
        CoursesState.error(
          courses: state.courses,
          error: 'Ошибка удаления курса',
          event: event,
        ),
      );
    }
  }

  Future<void> _fetchCourses(
    CoursesEvent$FetchCourses event,
    Emitter<CoursesState> emit,
  ) async {
    emit(
      CoursesState.loading(
        courses: state.courses,
      ),
    );

    try {
      final courses = switch (event.role) {
        UserRole.student => await _coursesRepository.getTeacherCourses(
            event.searchQuery,
          ),
        _ => await _coursesRepository.getStudentCourses(
            event.searchQuery,
          ),
      };
      emit(
        CoursesState.idle(
          courses: courses,
        ),
      );
    } on Object catch (_) {
      emit(
        CoursesState.error(
          courses: state.courses,
          error: 'Ошибка загрузки курсов',
          event: event,
        ),
      );
    }
  }

  Future<void> _enrollCourse(
    CoursesEvent$EnrollCourse event,
    Emitter<CoursesState> emit,
  ) async {
    emit(
      CoursesState.loading(
        courses: state.courses,
      ),
    );

    try {
      await _coursesRepository.enrollCourse(
        event.courseId,
      );
      final courses = await _coursesRepository.getStudentCourses(
        '',
      );
      emit(
        CoursesState.idle(
          courses: courses,
        ),
      );
    } on Object catch (_) {
      emit(
        CoursesState.error(
          courses: state.courses,
          error: 'Ошибка записи на курс',
          event: event,
        ),
      );
    }
  }
}
