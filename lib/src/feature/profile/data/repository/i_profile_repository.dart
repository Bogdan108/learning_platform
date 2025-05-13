import 'package:learning_platform/src/feature/profile/model/user.dart';
import 'package:learning_platform/src/feature/profile/model/user_name.dart';

abstract interface class IProfileRepository {
  Future<User> getUserInfo();
  Future<void> editUserInfo({
    String? password,
    UserName? fullName,
  });
}
