import 'package:learning_platform/src/feature/authorization/data/storage/token_storage.dart';
import 'package:learning_platform/src/feature/profile/data/data_source/i_profile_data_source.dart';
import 'package:learning_platform/src/feature/profile/data/repository/i_profile_repository.dart';
import 'package:learning_platform/src/feature/profile/model/user.dart';

class ProfileRepository implements IProfileRepository {
  final IProfileDataSource _dataSource;
  final TokenStorage tokenStorage;

  ProfileRepository(
      {required IProfileDataSource dataSource, required this.tokenStorage})
      : _dataSource = dataSource;

  String get token => tokenStorage.load() ?? '';

  @override
  Future<User> getUserInfo(String organizationId, String token) =>
      _dataSource.getUserInfo(organizationId, token);
}
