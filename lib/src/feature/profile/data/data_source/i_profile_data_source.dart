import 'package:learning_platform/src/feature/profile/model/user.dart';

abstract interface class IProfileDataSource {
  Future<User> getUserInfo(String organizationId, String token);
}
