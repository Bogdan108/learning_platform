import 'package:dio/dio.dart';
import 'package:learning_platform/src/feature/profile/data/data_source/i_profile_data_source.dart';
import 'package:learning_platform/src/feature/profile/model/user.dart';
import 'package:learning_platform/src/feature/profile/model/user_name.dart';
import 'package:learning_platform/src/feature/profile/model/user_role.dart';

class ProfileDataSource implements IProfileDataSource {
  final Dio _dio;

  ProfileDataSource({required Dio dio}) : _dio = dio;

  // @override
  // Future<User> getUserInfo(String organizationId, String token) async {
  //   final response = await _dio.get<Map<String, dynamic>>(
  //     '/user/info',
  //     queryParameters: {
  //       'organization_id': organizationId,
  //       'token': token,
  //     },
  //   );
  //   if (response.data != null) {
  //     return User.fromJson(response.data!);
  //   }
  //   throw Exception('Unexpected response when fetching user info');
  // }

  // @override
  // Future<void> editUserInfo(
  //   String organizationId,
  //   String token,
  //   String? password,
  //   UserName? fullName,
  // ) async {
  //   await _dio.put<void>('/user/info', queryParameters: {
  //     'organization_id': organizationId,
  //     'token': token,
  //   }, data: {
  //     if (password != null) 'password': password,
  //     if (fullName != null) 'full_name': fullName.toJson(),
  //   });
  // }

  @override
  Future<User> getUserInfo(String organizationId, String token) async => Future.delayed(
        const Duration(seconds: 1),
        () => const User(
          fullName: UserName(
            firstName: 'Bogdan',
            secondName: 'Luckyanchuk',
            middleName: 'Sergeevich',
          ),
          role: UserRole.teacher,
          email: 'ibogdan533@gmail.com',
        ),
      );

  @override
  Future<void> editUserInfo(
    String organizationId,
    String token,
    String? password,
    UserName? fullName,
  ) async =>
      Future.delayed(
        const Duration(seconds: 1),
      );
}
