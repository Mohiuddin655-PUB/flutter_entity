part of 'entity.dart';

/// Extension methods to provide helper functionalities for object types that represent entities.
extension EntityObjectHelper on Object? {
  /// Checks if the object is a map representing an entity.
  bool get isEntity => this is Map;

  /// Retrieves a value associated with the given key from the entity.
  ///
  /// If the object is not an entity or if the key doesn't exist, returns null.
  T? entityValue<T>(
    String key, [
    EntityBuilder<T>? builder,
  ]) {
    return isEntity ? Entity.value(key, this, builder) : null;
  }

  /// Retrieves a list of values associated with the given key from the entity.
  ///
  /// If the object is not an entity or if the key doesn't exist, returns null.
  List<T>? entityValues<T>(
    String key, [
    EntityBuilder<T>? builder,
  ]) {
    return isEntity ? Entity.values(key, this, builder) : null;
  }
}
