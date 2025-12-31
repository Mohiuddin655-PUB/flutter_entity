import 'helper.dart';

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
    return isEntity ? EntityHelper.value(key, this, builder) : null;
  }

  /// Retrieves a list of values associated with the given key from the entity.
  ///
  /// If the object is not an entity or if the key doesn't exist, returns null.
  List<T>? entityValues<T>(
    String key, [
    EntityBuilder<T>? builder,
  ]) {
    return isEntity ? EntityHelper.values(key, this, builder) : null;
  }
}

extension StringHelper on String? {
  bool get isRef => this != null && this!.startsWith("@");
  bool get isCounterRef => this != null && this!.startsWith("#");
  bool get isUrl => this != null && this!.startsWith("https://");
}

extension StringsHelper on List<String>? {
  bool get isRefs =>
      this != null && this!.isNotEmpty && this!.every((e) => e.isRef);
  bool get isCounterRefs =>
      this != null && this!.isNotEmpty && this!.every((e) => e.isCounterRef);
  bool get isUrls {
    return this != null && this!.isNotEmpty && this!.every((e) => e.isUrl);
  }
}
