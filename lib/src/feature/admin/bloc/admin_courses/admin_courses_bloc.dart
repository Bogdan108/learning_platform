import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_platform/src/common/utils/set_state_mixin.dart';
import 'package:learning_platform/src/feature/admin/bloc/admin_courses/admin_courses_bloc_event.dart';
import 'package:learning_platform/src/feature/admin/bloc/admin_courses/admin_courses_bloc_state.dart';
import 'package:learning_platform/src/feature/admin/data/repository/i_admin_repository.dart';
import 'package:learning_platform/src/feature/courses/model/course_request.dart';

class AdminCoursesBloc
    extends Bloc<AdminCoursesBlocEvent, AdminCoursesBlocState>
    with SetStateMixin {
  final IAdminRepository _repo;

  AdminCoursesBloc({
    required IAdminRepository repository,
    AdminCoursesBlocState? initialState,
  })  : _repo = repository,
        super(
          initialState ?? const AdminCoursesBlocState.idle(),
        ) {
    on<AdminCoursesBlocEvent>(
      (event, emit) => switch (event) {
        FetchCoursesEvent() => _fetchCourses(event, emit),
        EditCourseEvent() => _editCourse(event, emit),
        DeleteCourseEvent() => _deleteCourse(event, emit),
      },
    );
  }

  Future<void> _fetchCourses(
    FetchCoursesEvent e,
    Emitter<AdminCoursesBlocState> emit,
  ) async {
    emit(AdminCoursesBlocState.loading(courses: state.courses));
    try {
      final list = await _repo.getAllCourses(e.searchQuery);
      emit(AdminCoursesBlocState.idle(courses: list));
    } on Object catch (e, st) {
      emit(
        AdminCoursesBlocState.error(
          courses: state.courses,
          error: e.toString(),
        ),
      );
      onError(e, st);
    }
  }

  Future<void> _editCourse(
    EditCourseEvent e,
    Emitter<AdminCoursesBlocState> emit,
  ) async {
    emit(AdminCoursesBlocState.loading(courses: state.courses));
    try {
      final courseRequest =
          CourseRequest(name: e.name, description: e.description);
      await _repo.editCourse(e.courseId, courseRequest);
      final list = await _repo.getAllCourses('');
      emit(AdminCoursesBlocState.idle(courses: list));
    } on Object catch (e, st) {
      emit(
        AdminCoursesBlocState.error(
          courses: state.courses,
          error: e.toString(),
        ),
      );
      onError(e, st);
    }
  }

  Future<void> _deleteCourse(
    DeleteCourseEvent e,
    Emitter<AdminCoursesBlocState> emit,
  ) async {
    emit(AdminCoursesBlocState.loading(courses: state.courses));
    try {
      await _repo.deleteCourse(e.courseId);
      final list = await _repo.getAllCourses('');
      emit(AdminCoursesBlocState.idle(courses: list));
    } on Object catch (e, st) {
      emit(
        AdminCoursesBlocState.error(
          courses: state.courses,
          error: e.toString(),
        ),
      );
      onError(e, st);
    }
  }
}
