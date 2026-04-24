/// Represents the keys associated with an entity.
class EntityKey {
  /// The ID key.
  final String id;

  /// The timestamp key.
  final String createdAt;

  /// Default constructor for [EntityKey].
  const EntityKey({
    this.id = "id",
    this.createdAt = "createdAt",
  });

  Iterable<String> get keys => [id, createdAt];

  /// Singleton instance of [EntityKey].
  ///
  /// It provides access to commonly used entity keys.
  static EntityKey? _i;

  /// Retrieves the singleton instance of [EntityKey].
  ///
  /// If the instance has not been initialized, creates a new instance and returns it.
  static EntityKey get i => _i ??= const EntityKey();
}
