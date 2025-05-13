import 'package:learning_platform/src/feature/profile/model/user.dart';
import 'package:learning_platform/src/feature/profile/model/user_name.dart';

abstract interface class IProfileDataSource {
  Future<User> getUserInfo(String organizationId, String token);

  Future<void> editUserInfo(
    String organizationId,
    String token,
    String? password,
    UserName? fullName,
  );
}
