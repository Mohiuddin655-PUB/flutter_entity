part of 'entity.dart';

/// Represents the keys associated with an entity.
class EntityKey {
  /// The ID key.
  final String id;

  /// The timestamp key.
  final String timeMills;

  /// Default constructor for [EntityKey].
  const EntityKey({
    this.id = "id",
    this.timeMills = "time_mills",
  });

  /// Singleton instance of [EntityKey].
  ///
  /// It provides access to commonly used entity keys.
  static EntityKey? _i;

  /// Retrieves the singleton instance of [EntityKey].
  ///
  /// If the instance has not been initialized, creates a new instance and returns it.
  static EntityKey get i => _i ??= const EntityKey();
}
