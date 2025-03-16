import 'dart:async';

import 'package:learning_platform/src/core/utils/preferences_dao.dart';
import 'package:learning_platform/src/feature/authorization/data/storage/i_token_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// A class for token storage that implements the [ITokenStorage] interface.
class TokenStorage implements ITokenStorage<String> {
  // static const String _tokenKey = 'authorization.access_token';
  final SharedPreferences _sharedPreferences;

  /// Constructs a [TokenStorage] instance with the provided [SharedPreferences].
  TokenStorage({required SharedPreferences sharedPreferences})
      : _sharedPreferences = sharedPreferences,
        _accessToken = TypedEntry(
          sharedPreferences: sharedPreferences,
          key: 'auth_access_token',
        );

  late final PreferencesEntry<String> _accessToken;
  final _streamController = StreamController<String?>.broadcast();

  /// Clears the stored token.
  @override
  Future<void> clear() async {
    await _sharedPreferences.clear();
  }

  /// Loads the token from storage.
  @override
  String? load() => _accessToken.read();

  /// Saves the token to storage.
  @override
  Future<void> save(String token) async {
    await _accessToken.set(token);
  }

  @override
  Stream<String?> authStream() => _streamController.stream;

  /// Closes the token storage.
  @override
  Future<void> close() async {
    await _streamController.close();
  }
}
