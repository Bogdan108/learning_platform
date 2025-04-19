import 'package:learning_platform/src/feature/profile/model/user.dart';

abstract interface class IProfileRepository {
  Future<User> getUserInfo(String organizationId, String token);
}
