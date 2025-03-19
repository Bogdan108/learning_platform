/// Model for course
class Course {
  final String title;
  final String description;
  final int studentCount;
  final String status;
  final List<String> materials;
  final List<String> students;

  const Course({
    required this.title,
    required this.description,
    required this.studentCount,
    required this.status,
    required this.materials,
    required this.students,
  });

  Course copyWith({
    String? title,
    String? description,
    int? studentCount,
    String? status,
    List<String>? materials,
    List<String>? students,
  }) =>
      Course(
        title: title ?? this.title,
        description: description ?? this.description,
        studentCount: studentCount ?? this.studentCount,
        status: status ?? this.status,
        materials: materials ?? this.materials,
        students: students ?? this.students,
      );
}
