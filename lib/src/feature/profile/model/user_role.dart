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
        UserRole.student => 'Ученик',
        UserRole.teacher => 'Учитель',
        UserRole.admin => 'Админ',
        UserRole.unauthorized => 'Неавторизован',
      };
}
