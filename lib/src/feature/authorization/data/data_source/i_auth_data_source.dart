import 'package:learning_platform/src/feature/profile/model/user_name.dart';

/// Data source for authentication
abstract interface class IAuthDataSource {
  /// Register a new user.
  Future<String> register(
    String organizationId,
    String email,
    String password,
    UserName userName,
  );

  /// Log in a user.
  Future<String> login(
    String organizationId,
    String email,
    String password,
  );

  /// Send code to user email
  Future<void> sendCodeToEmail(
    String token,
  );

  /// Validate an email address.
  Future<void> verifyEmail(
    String code,
    String token,
  );
}
