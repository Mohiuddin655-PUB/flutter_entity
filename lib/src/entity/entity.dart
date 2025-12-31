import 'dart:convert';

import 'equality.dart';
import 'helper.dart';
import 'key.dart';

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
  })  : idOrNull = id ?? EntityHelper.generateID,
        timeMillsOrNull = timeMills ?? EntityHelper.generateTimeMills,
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

  Iterable<Object?> get props => [idOrNull, timeMillsOrNull];

  bool iterableEquals<T>(
    Iterable<T> a,
    Iterable<T> b, {
    bool unordered = false,
    bool Function(T a, T b)? equals,
  }) {
    equals ??= (x, y) => x == y;

    if (a.isEmpty && b.isEmpty) return true;

    if (a.length != b.length) return false;

    if (!unordered) {
      final itA = a.iterator;
      final itB = b.iterator;

      while (itA.moveNext() && itB.moveNext()) {
        if (!equals(itA.current, itB.current)) return false;
      }
      return true;
    }

    // unordered comparison
    final used = List<bool>.filled(b.length, false);
    final listB = b.toList();

    for (final itemA in a) {
      bool found = false;

      for (int i = 0; i < listB.length; i++) {
        if (!used[i] && equals(itemA, listB[i])) {
          used[i] = true;
          found = true;
          break;
        }
      }

      if (!found) return false;
    }

    return true;
  }

  @override
  int get hashCode {
    return Object.hashAll(props.map((e) {
      if (e is bool) return e;
      if (e is num) return e;
      if (e is String) return e;
      return hash(e);
    }));
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other.runtimeType != runtimeType) return false;
    if (other is! Entity) return false;
    if (other.idOrNull != idOrNull) return false;
    if (other.timeMillsOrNull != timeMillsOrNull) return false;
    if (!iterableEquals(other.props, props)) return false;
    return true;
  }

  @override
  String toString() => "Entity#$hashCode";
}
