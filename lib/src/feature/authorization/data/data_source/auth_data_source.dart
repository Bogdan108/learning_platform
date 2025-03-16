import 'package:dio/dio.dart';
import 'package:learning_platform/src/feature/authorization/data/data_source/i_auth_data_source.dart';
import 'package:learning_platform/src/feature/profile/model/user_name.dart';

/// Data source implementation for authentication operations using Dio.
class AuthDataSource implements IAuthDataSource {
  final Dio _dio;

  /// Creates an [AuthDataSource] instance with the provided [Dio] client.
  AuthDataSource({required Dio dio}) : _dio = dio;

  /// Logs in a user using [organizationId], [email] and [password].
  ///
  /// Calls the POST endpoint `/user/authorize` and returns a token string on success.
  @override
  Future<String> login(
    String organizationId,
    String email,
    String password,
  ) async {
    final body = await _dio.post<Map<String, Object?>>(
      '/user/authorize',
      queryParameters: {'organization_id': organizationId},
      data: {
        'email': email,
        'password': password,
      },
    );

    // Check if response contains access_token
    if (body
        case {
          'token': final String accessToken,
        }) {
      return accessToken;
    }

    throw FormatException(
      'Returned response is not understood by the application',
      body,
    );
  }

  /// Registers a new user using [organizationId], [email], [password] and [userName].
  ///
  /// Calls the POST endpoint `/user/register` with the user data and returns a token on success.
  @override
  Future<String> register(
    String organizationId,
    String email,
    String password,
    UserName userName,
  ) async {
    final body = await _dio.post<Map<String, Object?>>(
      '/user/register',
      queryParameters: {'organization_id': organizationId},
      data: {
        'email': email,
        'password': password,
        'full_name': userName.toJson(),
      },
    );

    // Check if response contains access_token
    if (body
        case {
          'token': final String accessToken,
        }) {
      return accessToken;
    }

    throw FormatException(
      'Returned response is not understood by the application',
      body,
    );
  }

  /// Sends a verification code to email
  ///
  /// Calls the POST endpoint `/user/email/send_verification_code`.
  @override
  Future<void> sendCodeToEmail() => _dio.post<Map<String, Object?>>(
        '/user/email/send_verification_code',
      );

  /// Verifies the email using [code].
  ///
  /// Calls the POST endpoint `/user/email/verify` with a JSON body.
  @override
  Future<void> verifyEmail(String code) => _dio.post<Map<String, Object?>>(
        '/user/email/verify',
        data: {
          'code': code,
        },
      );
}
