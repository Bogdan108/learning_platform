import 'package:learning_platform/src/feature/profile/model/user.dart';

abstract interface class IProfileRepository {
  Future<User> getUserInfo();
  Future<void> editUserInfo();
}
