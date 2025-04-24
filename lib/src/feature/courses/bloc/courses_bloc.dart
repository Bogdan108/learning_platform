import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_platform/src/common/utils/set_state_mixin.dart';
import 'package:learning_platform/src/feature/courses/bloc/courses_bloc_event.dart';
import 'package:learning_platform/src/feature/courses/bloc/courses_bloc_state.dart';
import 'package:learning_platform/src/feature/courses/data/repository/courses_repository.dart';
import 'package:learning_platform/src/feature/courses/data/repository/i_courses_repository.dart';
import 'package:learning_platform/src/feature/courses/model/course_request.dart';
import 'package:learning_platform/src/feature/profile/model/user_role.dart';

class CoursesBloc extends Bloc<CoursesBlocEvent, CoursesBlocState>
    with SetStateMixin {
  final ICoursesRepository _coursesRepository;

  CoursesBloc({
    required CoursesRepository coursesRepository,
    CoursesBlocState? initialState,
  })  : _coursesRepository = coursesRepository,
        super(initialState ?? const CoursesBlocState.idle()) {
    on<CoursesBlocEvent>(
      (event, emit) => switch (event) {
        FetchCoursesEvent() => _fetchCourses(event, emit),
        CreateCourseEvent() => _createCourse(event, emit),
        EditCourseEvent() => _editCourse(event, emit),
        DeleteCourseEvent() => _deleteCourse(event, emit),
        EnrollCourseEvent() => _enrollCourse(event, emit),
      },
    );
  }

  Future<void> _createCourse(
    CreateCourseEvent event,
    Emitter<CoursesBlocState> emit,
  ) async {
    emit(
      CoursesBlocState.loading(
        courses: state.courses,
      ),
    );

    try {
      final courseRequest =
          CourseRequest(name: event.name, description: event.description);
      await _coursesRepository.createCourse(courseRequest);

      final courses = await _coursesRepository.getTeacherCourses(
        '',
      );
      emit(
        CoursesBlocState.idle(
          courses: courses,
        ),
      );
    } on Object catch (e, st) {
      emit(
        CoursesBlocState.error(
          courses: state.courses,
          error: e.toString(),
        ),
      );
      onError(e, st);
    }
  }

  Future<void> _editCourse(
    EditCourseEvent event,
    Emitter<CoursesBlocState> emit,
  ) async {
    emit(
      CoursesBlocState.loading(
        courses: state.courses,
      ),
    );

    try {
      final courseRequest =
          CourseRequest(name: event.name, description: event.description);
      await _coursesRepository.editCourse(
        event.courseId,
        courseRequest,
      );

      final courses = await _coursesRepository.getTeacherCourses(
        '',
      );
      emit(
        CoursesBlocState.idle(
          courses: courses,
        ),
      );
    } on Object catch (e, st) {
      emit(
        CoursesBlocState.error(
          courses: state.courses,
          error: e.toString(),
        ),
      );
      onError(e, st);
    }
  }

  Future<void> _deleteCourse(
    DeleteCourseEvent event,
    Emitter<CoursesBlocState> emit,
  ) async {
    emit(
      CoursesBlocState.loading(
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
        CoursesBlocState.idle(
          courses: courses,
        ),
      );
    } on Object catch (e, st) {
      emit(
        CoursesBlocState.error(
          courses: state.courses,
          error: e.toString(),
        ),
      );
      onError(e, st);
    }
  }

  Future<void> _fetchCourses(
    FetchCoursesEvent event,
    Emitter<CoursesBlocState> emit,
  ) async {
    emit(
      CoursesBlocState.loading(
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
        CoursesBlocState.idle(
          courses: courses,
        ),
      );
    } on Object catch (e, st) {
      emit(
        CoursesBlocState.error(
          courses: state.courses,
          error: e.toString(),
        ),
      );
      onError(e, st);
    }
  }

  Future<void> _enrollCourse(
    EnrollCourseEvent event,
    Emitter<CoursesBlocState> emit,
  ) async {
    emit(
      CoursesBlocState.loading(
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
        CoursesBlocState.idle(
          courses: courses,
        ),
      );
    } on Object catch (e, st) {
      emit(
        CoursesBlocState.error(
          courses: state.courses,
          error: e.toString(),
        ),
      );
      onError(e, st);
    }
  }
}
