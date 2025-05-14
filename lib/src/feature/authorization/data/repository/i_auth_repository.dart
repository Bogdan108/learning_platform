import 'package:learning_platform/src/feature/authorization/model/auth_status_model.dart';
import 'package:learning_platform/src/feature/authorization/model/user_authorized.dart';
import 'package:learning_platform/src/feature/profile/model/user_name.dart';

/// Interface for authentication operations.
abstract interface class IAuthRepository {
  /// Stream with auth status
  Stream<AuthenticationStatus> get authStatus;

  /// Register a new user.
  Future<String> register(
    String organizationId,
    String email,
    String password,
    UserName userName,
  );

  /// Log in a user.
  Future<UserAuthorized> login(
    String organizationId,
    String email,
    String password,
  );

  /// Validate an email address.
  Future<void> verifyEmail(String code);

  /// Validate an email address.
  Future<void> sendCodeToEmail(String token);

  /// Log out the current user.
  Future<void> logout();
}
