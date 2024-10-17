part of 'entity.dart';

/// Extension methods to provide helper functionalities for object types that represent entities.
extension EntityObjectHelper on Object? {
  /// Checks if the object is a map representing an entity.
  bool get isEntity => this is Map<String, dynamic>;

  /// Retrieves a value associated with the given key from the entity.
  ///
  /// If the object is not an entity or if the key doesn't exist, returns null.
  T? entityValue<T>(
    String key, [
    EntityBuilder<T>? builder,
  ]) {
    return isEntity ? Entity.value(key, this) : null;
  }

  /// Retrieves a list of values associated with the given key from the entity.
  ///
  /// If the object is not an entity or if the key doesn't exist, returns null.
  List<T>? entityValues<T>(
    String key, [
    EntityBuilder<T>? builder,
  ]) {
    return isEntity ? Entity.values(key, this) : null;
  }
}

extension EntityMapHelper on Map<String, dynamic> {
  bool isInsertable(String key, value) {
    return key.isNotEmpty && value != null;
  }

  Map<String, dynamic> put(String key, value, [bool nullable = false]) {
    if (nullable || isInsertable(key, value)) {
      return this..putIfAbsent(key, () => value);
    } else {
      return this;
    }
  }
}
