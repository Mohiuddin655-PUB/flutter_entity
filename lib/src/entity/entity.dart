import 'dart:convert';

import 'equality.dart';

part 'extensions.dart';
part 'key.dart';

/// Defines a function signature for building entities from dynamic data.
typedef EntityBuilder<T> = T Function(dynamic value);

/// Represents an entity with a unique identifier and timestamp.
///
/// This is a base class for all entities in the system. Each entity has:
/// - A unique identifier ([id])
/// - A timestamp ([timeMills])
/// - An associated key of type [Key]
///
/// Type parameter [Key] must extend [EntityKey].
class Entity<Key extends EntityKey> extends DeepCollectionEquality {
  // ============================================================================
  // FIELDS
  // ============================================================================

  final String? idOrNull;
  final int? timeMillsOrNull;
  final Key? _key;

  // ============================================================================
  // CONSTRUCTORS
  // ============================================================================

  /// Creates an entity with optional id, timeMills, and key
  const Entity({
    String? id,
    int? timeMills,
    Key? key,
  })  : idOrNull = id,
        timeMillsOrNull = timeMills,
        _key = key;

  /// Creates an entity with auto-generated id and timeMills if not provided
  Entity.auto({
    String? id,
    int? timeMills,
    Key? key,
  })  : idOrNull = id ?? generateID,
        timeMillsOrNull = timeMills ?? generateTimeMills,
        _key = key;

  // ============================================================================
  // GETTERS - Basic Properties
  // ============================================================================

  /// The unique identifier of the entity as a string
  String get id => idOrNull ?? '';

  /// The timestamp in milliseconds since epoch
  int get timeMills => timeMillsOrNull ?? 0;

  /// The unique identifier of the entity as an integer
  int get idInt => int.tryParse(id) ?? 0;

  /// The key associated with the entity
  Key get key => _key ?? makeKey();

  /// The timestamp as a DateTime object
  DateTime get dateTime => dateTimeOrNull ?? DateTime.now();

  /// The timestamp as a DateTime object, or null if invalid
  DateTime? get dateTimeOrNull {
    if (timeMillsOrNull == null || timeMillsOrNull! <= 0) return null;
    return DateTime.fromMillisecondsSinceEpoch(timeMillsOrNull!);
  }

  // ============================================================================
  // GETTERS - Data Representation
  // ============================================================================

  /// Returns the entity as a map with all fields
  Map<String, dynamic> get source {
    return {
      key.id: idOrNull,
      key.timeMills: timeMillsOrNull,
    };
  }

  /// Returns the entity as a map with only insertable fields
  Map<String, dynamic> get filtered {
    final entries = source.entries.where((e) => isInsertable(e.key, e.value));
    return Map.fromEntries(entries);
  }

  /// Returns the entity as a JSON string
  String get json => jsonEncode(source);

  /// Returns the filtered entity as a JSON string
  String get filteredJson => jsonEncode(filtered);

  /// Returns keys that are ignored (not insertable)
  Iterable<String> get ignoredKeys => source.entries
      .where((e) => !isInsertable(e.key, e.value))
      .map((e) => e.key);

  // ============================================================================
  // METHODS - Instance
  // ============================================================================

  /// Checks if a field is insertable (valid key and non-null value)
  bool isInsertable(String key, dynamic value) {
    return this.key.keys.contains(key) && value != null;
  }

  /// Constructs the key for the entity.
  ///
  /// Subclasses must override this method to return their specific key type.
  Key makeKey() {
    try {
      return const EntityKey() as Key;
    } catch (_) {
      throw UnimplementedError(
        "You must override makeKey() and return the current key from sub-entity class.",
      );
    }
  }

  // ============================================================================
  // STATIC METHODS - Generation
  // ============================================================================

  /// Generates a unique identifier based on current timestamp
  static String get generateID => generateTimeMills.toString();

  /// Generates a timestamp in milliseconds since epoch
  static int get generateTimeMills => DateTime.now().millisecondsSinceEpoch;

  // ============================================================================
  // STATIC METHODS - Value Extraction
  // ============================================================================

  /// Extracts and converts a value from source to type [T]
  ///
  /// Supports automatic conversion between:
  /// - num ↔ int, double, String
  /// - String ↔ num, int, double, bool
  /// - Custom types via [builder]
  static T? value<T>(
    String key,
    dynamic source, [
    EntityBuilder<T>? builder,
  ]) {
    final value = source is Map ? source[key] : null;
    return _v(value, builder);
  }

  /// Extracts and converts a list of values from source to type [T]
  static List<T>? values<T>(
    String key,
    dynamic source, [
    EntityBuilder<T>? builder,
  ]) {
    final data = source is Map ? source[key] : null;
    final iterable = _vs(data, builder);
    if (iterable == null) return null;
    return List.from(iterable);
  }

  // ============================================================================
  // PRIVATE STATIC METHODS - Type Conversion
  // ============================================================================

  /// Internal method to convert a single value to type [T]
  static T? _v<T>(
    dynamic source, [
    EntityBuilder<T>? builder,
  ]) {
    if (source == null) return null;
    if (source is T) return source;

    // Handle numeric conversions
    if (source is num) {
      if (T == int) return source.toInt() as T;
      if (T == double) return source.toDouble() as T;
      if (T == String) return source.toString() as T;
    }

    // Handle string conversions
    if (source is String) {
      // String to number
      if (T == num || T == int || T == double) {
        final number = num.tryParse(source);
        if (number != null) {
          if (T == int) return number.toInt() as T;
          if (T == double) return number.toDouble() as T;
          return number as T;
        }
      }
      // String to bool
      if (T == bool) {
        final boolean = bool.tryParse(source);
        if (boolean != null) return boolean as T;
      }
    }

    // Use custom builder if provided
    if (builder != null) {
      return builder(source);
    }

    return null;
  }

  /// Internal method to convert an iterable of values to type [T]
  static Iterable<T>? _vs<T>(
    dynamic source, [
    EntityBuilder<T>? builder,
  ]) {
    if (source == null || source is! Iterable) return null;
    return source.map((e) => _v(e, builder)).whereType<T>();
  }

  // ============================================================================
  // OVERRIDES
  // ============================================================================

  @override
  int get hashCode {
    return Object.hash(idOrNull, timeMillsOrNull);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other.runtimeType != runtimeType) return false;
    if (other is! Entity) return false;
    if (other.idOrNull != idOrNull) return false;
    if (other.timeMillsOrNull != timeMillsOrNull) return false;
    return true;
  }

  @override
  String toString() => "Entity#$hashCode";
}
