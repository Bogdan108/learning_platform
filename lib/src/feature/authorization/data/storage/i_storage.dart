import 'dart:async';

/// [IStorage] interface for stores and manages the [T] data.
abstract interface class IStorage<T> {
  /// Load the [T] from the storage.
  T? load();

  /// Save the [T] to the storage.
  Future<void> save(T token);

  /// Clears the [T].
  Future<void> clear();
}
