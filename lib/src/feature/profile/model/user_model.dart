import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_model.freezed.dart';

/// A sealed class that represents a user in the application with different roles.
///
/// This class is implemented using the [freezed] package and supports union types
/// for different user roles. The common properties include:
/// - [firstName]: The user's first name.
/// - [lastName]: The user's last name.
/// - [mail]: The user's email address.
/// - [role]: The role identifier of the user.
///
/// The class also provides computed getters to easily check the type of user.
@freezed
sealed class UserModel with _$UserModel {
  /// The common properties for a user.
  final String firstName;
  final String lastName;
  final String mail;
  final String role;

  /// Private constructor for [UserModel] to allow the declaration of shared properties
  /// and computed getters.
  const UserModel._({
    required this.firstName,
    required this.lastName,
    required this.mail,
    required this.role,
  });

  /// Returns `true` if the user is unauthenticated.
  bool get isUnauthenticated => this is UnauthenticatedUser;

  /// Returns `true` if the user is a student.
  bool get isStudent => this is Student;

  /// Returns `true` if the user is a teacher.
  bool get isTeacher => this is Teacher;

  /// Returns `true` if the user is an administrator.
  bool get isAdmin => this is Admin;

  /// Factory constructor for creating an unauthenticated user.
  const factory UserModel.unauthenticatedUser() = UnauthenticatedUser;

  /// Factory constructor for creating a student user.
  const factory UserModel.student() = Student;

  /// Factory constructor for creating a teacher user.
  const factory UserModel.teacher() = Teacher;

  /// Factory constructor for creating an administrator user.
  const factory UserModel.admin() = Admin;
}
