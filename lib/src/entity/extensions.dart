part of 'entity.dart';

/// Extension methods to provide helper functionalities for object types that represent entities.
extension EntityObjectHelper on Object? {
  /// Checks if the object is a map representing an entity.
  bool get isEntity => this is Map<String, dynamic>;

  /// Retrieves the entity ID if the object represents an entity.
  String? get entityId => isEntity ? Entity.autoId(this) : null;

  /// Retrieves the entity timestamp if the object represents an entity.
  int? get entityTimeMills => isEntity ? Entity.autoTimeMills(this) : null;

  /// Retrieves an object associated with the given key from the entity.
  T? entityObject<T>(
    String key,
    EntityBuilder<T> builder,
  ) {
    return isEntity ? Entity.object(key, this, builder) : null;
  }

  /// Retrieves a list of objects associated with the given key from the entity.
  List<T>? entityObjects<T>(
    String key,
    EntityBuilder<T> builder,
  ) {
    return isEntity ? Entity.objects(key, this, builder) : null;
  }

  /// Retrieves an object of a specific type associated with the given key from the entity.
  T? entityType<T>(
    String key,
    EntityBuilder<T> builder,
  ) {
    return isEntity ? Entity.type(key, this, builder) : null;
  }

  /// Retrieves a value associated with the given key from the entity.
  ///
  /// If the object is not an entity or if the key doesn't exist, returns null.
  T? entityValue<T>(String key) {
    return isEntity ? Entity.value(key, this) : null;
  }

  /// Retrieves a list of values associated with the given key from the entity.
  ///
  /// If the object is not an entity or if the key doesn't exist, returns null.
  List<T>? entityValues<T>(String key) {
    return isEntity ? Entity.values(key, this) : null;
  }
}

extension EntityMapHelper on Map<String, dynamic> {
  bool isInsertable(String key, value) {
    return key.isNotEmpty && value != null;
  }

  Map<String, dynamic> set(String key, value, [bool nullable = false]) {
    if (nullable || isInsertable(key, value)) {
      return this..putIfAbsent(key, () => value);
    } else {
      return this;
    }
  }

  T? find<T>(String key) {
    final i = this[key];
    if (i is T) {
      return i;
    } else {
      return null;
    }
  }
}
