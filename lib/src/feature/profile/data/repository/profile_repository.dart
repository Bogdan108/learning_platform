import 'package:learning_platform/src/feature/authorization/data/storage/i_storage.dart';
import 'package:learning_platform/src/feature/authorization/data/storage/token_storage.dart';
import 'package:learning_platform/src/feature/profile/data/data_source/i_profile_data_source.dart';
import 'package:learning_platform/src/feature/profile/data/repository/i_profile_repository.dart';
import 'package:learning_platform/src/feature/profile/model/user.dart';

class ProfileRepository implements IProfileRepository {
  final IProfileDataSource _dataSource;
  final TokenStorage tokenStorage;
  final IStorage<String> _orgIdStorage;

  ProfileRepository({
    required IProfileDataSource dataSource,
    required this.tokenStorage,
    required IStorage<String> orgIdStorage,
  })  : _dataSource = dataSource,
        _orgIdStorage = orgIdStorage;

  String get token => tokenStorage.load() ?? '';

  @override
  Future<User> getUserInfo() {
    final organizationId = _orgIdStorage.load();
    return _dataSource.getUserInfo(organizationId ?? '', token);
  }
}
