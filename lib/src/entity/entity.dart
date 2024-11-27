import 'dart:convert';

part 'extensions.dart';
part 'key.dart';

/// Defines a function signature for building entities from dynamic data.
typedef EntityBuilder<T> = T Function(dynamic value);

/// Represents an entity with a unique identifier and timestamp.
class Entity<Key extends EntityKey> {
  String? idOrNull;
  int? timeMillsOrNull;

  String get id => idOrNull ?? '';

  int get timeMills => timeMillsOrNull ?? 0;

  /// The unique identifier of the entity as an integer.
  int get idInt => int.tryParse(id) ?? 0;

  Entity({
    String? id,
    int? timeMills,
  })  : idOrNull = id ?? generateID,
        timeMillsOrNull = timeMills ?? generateTimeMills;

  /// Constructs an [Entity] object with optional id and timeMills.
  Entity.create({
    String? id,
    int? timeMills,
  })  : idOrNull = id,
        timeMillsOrNull = timeMills;

  Key? _key;

  /// The key associated with the entity.
  Key get key => _key ??= makeKey();

  Iterable<String> get ignoredKeys => source.entries
      .where((e) => !isInsertable(e.key, e.value))
      .map((e) => e.key);

  /// Returns the entity as a map.
  Map<String, dynamic> get source {
    return {
      key.id: idOrNull,
      key.timeMills: timeMillsOrNull,
    };
  }

  Map<String, dynamic> get filtered {
    final entries = source.entries.where((e) => isInsertable(e.key, e.value));
    return Map.fromEntries(entries);
  }

  String get json => jsonEncode(source);

  String get filteredJson => jsonEncode(filtered);

  bool isInsertable(String key, dynamic value) {
    return this.key.keys.contains(key) && value != null;
  }

  /// Constructs the key for the entity.
  Key makeKey() {
    try {
      return const EntityKey() as Key;
    } catch (_) {
      return throw UnimplementedError(
        "You must override makeKey() and return the current key from sub-entity class.",
      );
    }
  }

  /// Generates a unique identifier for the entity.
  static String get generateID => generateTimeMills.toString();

  /// Generates a timestamp for the entity.
  static int get generateTimeMills => DateTime.now().millisecondsSinceEpoch;

  /// Returns the value associated with the given key from the source.
  static T? _v<T>(
    dynamic source, [
    EntityBuilder<T>? builder,
  ]) {
    if (source == null) return null;
    if (source is T) return source;
    if (source is num) {
      if (T == int) return source.toInt() as T;
      if (T == double) return source.toDouble() as T;
      if (T == String) return source.toString() as T;
    }
    if (source is String) {
      if (T == num || T == int || T == double) {
        final number = num.tryParse(source);
        if (number != null) {
          if (T == int) return number.toInt() as T;
          if (T == double) return number.toDouble() as T;
          return number as T;
        }
      }
      if (T == bool) {
        final boolean = bool.tryParse(source);
        if (boolean != null) return boolean as T;
      }
    }
    if (builder != null) {
      return builder(source);
    }
    return null;
  }

  /// Returns a iterable of values associated, cast to the specified type.
  static Iterable<T>? _vs<T>(
    dynamic source, [
    EntityBuilder<T>? builder,
  ]) {
    if (source == null || source is! Iterable) return null;
    return source.map((e) => _v(e, builder)).whereType<T>();
  }

  /// Returns the value associated with the given key from the source.
  static T? value<T>(
    String key,
    dynamic source, [
    EntityBuilder<T>? builder,
  ]) {
    final value = source is Map ? source[key] : null;
    return _v(value, builder);
  }

  /// Returns a list of values associated with the given key from the source, cast to the specified type.
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

  /// Returns a string representation of the source map.
  @override
  String toString() => "$Entity#$hashCode($json)";
}
