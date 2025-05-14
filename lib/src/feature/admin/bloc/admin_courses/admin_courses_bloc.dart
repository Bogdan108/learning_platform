import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_platform/src/core/utils/set_state_mixin.dart';
import 'package:learning_platform/src/feature/admin/bloc/admin_courses/admin_courses_event.dart';
import 'package:learning_platform/src/feature/admin/bloc/admin_courses/admin_courses_state.dart';
import 'package:learning_platform/src/feature/admin/data/repository/i_admin_repository.dart';
import 'package:learning_platform/src/feature/course/model/course_request.dart';

class AdminCoursesBloc extends Bloc<AdminCoursesEvent, AdminCoursesState>
    with SetStateMixin {
  final IAdminRepository _repo;

  AdminCoursesBloc({
    required IAdminRepository repository,
    AdminCoursesState? initialState,
  })  : _repo = repository,
        super(
          initialState ?? const AdminCoursesState.idle(),
        ) {
    on<AdminCoursesEvent>(
      (event, emit) => switch (event) {
        AdminCoursesEvent$FetchCourses() => _fetchCourses(event, emit),
        AdminCoursesEvent$EditCourse() => _editCourse(event, emit),
        AdminCoursesEvent$DeleteCourse() => _deleteCourse(event, emit),
      },
    );
  }

  Future<void> _fetchCourses(
    AdminCoursesEvent$FetchCourses event,
    Emitter<AdminCoursesState> emit,
  ) async {
    emit(AdminCoursesState.loading(courses: state.courses));
    try {
      final list = await _repo.getAllCourses(event.searchQuery);
      emit(AdminCoursesState.idle(courses: list));
    } on Object catch (e, st) {
      emit(
        AdminCoursesState.error(
          courses: state.courses,
          error: 'Ошибка загрузки курсов',
          event: event,
        ),
      );
      onError(e, st);
    }
  }

  Future<void> _editCourse(
    AdminCoursesEvent$EditCourse event,
    Emitter<AdminCoursesState> emit,
  ) async {
    emit(AdminCoursesState.loading(courses: state.courses));
    try {
      final courseRequest =
          CourseRequest(name: event.name, description: event.description);
      await _repo.editCourse(event.courseId, courseRequest);
      final list = await _repo.getAllCourses('');
      emit(AdminCoursesState.idle(courses: list));
    } on Object catch (e, st) {
      emit(
        AdminCoursesState.error(
          courses: state.courses,
          error: 'Ошибка изменения курса',
          event: event,
        ),
      );
      onError(e, st);
    }
  }

  Future<void> _deleteCourse(
    AdminCoursesEvent$DeleteCourse event,
    Emitter<AdminCoursesState> emit,
  ) async {
    emit(AdminCoursesState.loading(courses: state.courses));
    try {
      await _repo.deleteCourse(event.courseId);
      final list = await _repo.getAllCourses('');
      emit(AdminCoursesState.idle(courses: list));
    } on Object catch (e, st) {
      emit(
        AdminCoursesState.error(
          courses: state.courses,
          error: 'Ошибка удаления курса',
          event: event,
        ),
      );
      onError(e, st);
    }
  }
}
