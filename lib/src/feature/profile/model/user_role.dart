/// Represents the possible roles for a user in the system.
enum UserRole {
  /// A role assigned to student users.
  student,

  /// A role assigned to teacher users.
  teacher,

  /// A role assigned to administrator users.
  admin,

  /// A role assigned to unauthorized users.
  unauthorized;

  String get name => switch (this) {
        UserRole.student => 'Студент',
        UserRole.teacher => 'Учитель',
        UserRole.admin => 'Администратор',
        UserRole.unauthorized => 'Неавторизован',
      };
}
