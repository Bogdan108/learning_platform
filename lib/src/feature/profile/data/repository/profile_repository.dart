import 'package:learning_platform/src/feature/authorization/data/storage/i_storage.dart';
import 'package:learning_platform/src/feature/authorization/data/storage/token_storage.dart';
import 'package:learning_platform/src/feature/profile/data/data_source/i_profile_data_source.dart';
import 'package:learning_platform/src/feature/profile/data/repository/i_profile_repository.dart';
import 'package:learning_platform/src/feature/profile/model/user.dart';
import 'package:learning_platform/src/feature/profile/model/user_name.dart';

class ProfileRepository implements IProfileRepository {
  final IProfileDataSource _dataSource;
  final TokenStorage _tokenStorage;
  final IStorage<String> _orgIdStorage;

  ProfileRepository({
    required IProfileDataSource dataSource,
    required TokenStorage tokenStorage,
    required IStorage<String> orgIdStorage,
  })  : _dataSource = dataSource,
        _orgIdStorage = orgIdStorage,
        _tokenStorage = tokenStorage;

  String get token => _tokenStorage.load() ?? '';
  String get organizationId => _orgIdStorage.load() ?? '';

  @override
  Future<User> getUserInfo() => _dataSource.getUserInfo(organizationId, token);

  @override
  Future<void> editUserInfo({
    String? password,
    UserName? fullName,
  }) async =>
      _dataSource.editUserInfo(
        organizationId,
        token,
        password,
        fullName,
      );
}
