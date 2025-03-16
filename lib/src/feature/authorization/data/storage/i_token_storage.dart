import 'dart:async';

/// [ITokenStorage] interface for stores and manages the Auth token.
abstract interface class ITokenStorage<T> {
  /// Load the Auth token from the storage.
  T? load();

  /// Save the Auth token to the storage.
  Future<void> save(T token);

  /// Clears the Auth token.
  Future<void> clear();

  /// Returns a stream of the Auth token.
  Stream<T?> authStream();

  /// Closes the storage.
  Future<void> close();
}
