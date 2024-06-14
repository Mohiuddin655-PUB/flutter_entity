part 'extensions.dart';
part 'key.dart';
part 'typedefs.dart';

/// Represents an entity with a unique identifier and timestamp.
class Entity<Key extends EntityKey> {
  String? _id;
  int? _timeMills;

  /// The unique identifier of the entity.
  String get id => _id ?? generateID;

  /// The unique identifier of the entity as an integer.
  int get idInt => int.tryParse(id) ?? 0;

  /// The timestamp associated with the entity.
  int get timeMills => _timeMills ?? generateTimeMills;

  set id(String value) => _id = value;

  set timeMills(int value) => _timeMills = value;

  /// Constructs an [Entity] object with optional id and timeMills.
  Entity({
    String? id,
    int? timeMills,
  })  : _id = id ?? generateID,
        _timeMills = timeMills ?? generateTimeMills;

  /// Constructs an [Entity] object from a dynamic source.
  factory Entity.from(dynamic source) {
    return Entity(
      id: Entity.autoId(source),
      timeMills: Entity.autoTimeMills(source),
    );
  }

  /// Constructs an [Entity] object from a dynamic source.
  factory Entity.root(dynamic source) => Entity.from(source);

  Key? _key;

  /// The key associated with the entity.
  Key get key => _key ??= makeKey();

  /// Returns the entity as a map.
  Map<String, dynamic> get source {
    return <String, dynamic>{}.set(key.id, id).set(key.timeMills, timeMills);
  }

  bool isInsertable(String key, value) => key.isNotEmpty;

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
  static dynamic _v(String key, dynamic source) {
    if (source is Map<String, dynamic>) {
      return source[key];
    } else {
      return null;
    }
  }

  /// Extracts and returns the auto-generated ID from the source.
  static String? autoId(dynamic source, [String? key]) {
    final data = _v(key ?? EntityKey.i.id, source);
    if (data is int || data is String) {
      return "$data";
    } else {
      return null;
    }
  }

  /// Extracts and returns the auto-generated timestamp from the source.
  static int? autoTimeMills(dynamic source, [String? key]) {
    final data = _v(key ?? EntityKey.i.timeMills, source);
    if (data is int) {
      return data;
    } else if (data is String) {
      return int.tryParse(data);
    } else {
      return null;
    }
  }

  /// Returns the value associated with the given key from the source, cast to the specified type.
  static T? value<T>(String key, dynamic source) {
    final data = _v(key, source);
    if (data is T) {
      return data;
    } else {
      return null;
    }
  }

  /// Returns a list of values associated with the given key from the source, cast to the specified type.
  static List<T>? values<T>(String key, dynamic source) {
    final data = _v(key, source);
    if (data is List) {
      final list = <T>[];
      for (var item in data) {
        if (item is T) {
          list.add(item);
        }
      }
      return list;
    } else {
      return null;
    }
  }

  /// Returns an object associated with the given key from the source, constructed using the provided builder.
  static T? type<T>(
    String key,
    dynamic source,
    EntityBuilder<T> builder,
  ) {
    final data = _v(key, source);
    if (data is String) {
      return builder.call(data);
    } else {
      return null;
    }
  }

  /// Returns an object associated with the given key from the source, constructed using the provided builder.
  static T? object<T>(
    String key,
    dynamic source,
    EntityBuilder<T> builder,
  ) {
    final data = _v(key, source);
    if (data is Map) {
      return builder.call(data);
    } else {
      return null;
    }
  }

  /// Returns a list of objects associated with the given key from the source, constructed using the provided builder.
  static List<T>? objects<T>(
    String key,
    dynamic source,
    EntityBuilder<T> builder,
  ) {
    final data = _v(key, source);
    if (data is List<Map<String, dynamic>>) {
      return data.map((e) => builder.call(e)).toList();
    } else {
      return null;
    }
  }

  /// Returns a string representation of the source map.
  @override
  String toString() => source.toString();
}
