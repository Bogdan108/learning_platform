import 'package:learning_platform/src/core/utils/preferences_dao.dart';
import 'package:learning_platform/src/feature/authorization/data/storage/i_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OrganizationIdStorage implements IStorage<String> {
  OrganizationIdStorage({required SharedPreferences sharedPreferences})
      : _organizationId = TypedEntry(
          sharedPreferences: sharedPreferences,
          key: 'organization_id',
        );

  late final PreferencesEntry<String> _organizationId;

  @override
  Future<void> clear() async => await _organizationId.remove();

  @override
  String? load() => _organizationId.read();

  @override
  Future<void> save(String token) async => _organizationId.set(token);
}
