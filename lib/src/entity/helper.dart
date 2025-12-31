import 'entity.dart';
import 'dart:io';

/// Defines a function signature for building entities from dynamic data.
typedef EntityBuilder<T> = T Function(dynamic value);

class EntityHelper {
  const EntityHelper._();

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
  // FILTERS
  // ============================================================================

  T? normalize<T extends Object?>(
    Entity? content,
    T? Function(Entity content) test,
    Entity? Function(Entity content) next,
  ) {
    if (content == null) return null;
    final data = test(content);
    if (data != null) return data;
    return normalize(next(content), test, next);
  }

  T? verifiedNum<T extends num>(T? value) {
    if (value == null) return null;
    if (value == 0) return null;
    return value;
  }

  String? verifiedString(
    String? value, {
    bool url = false,
    bool counterRef = false,
    bool objectRef = false,
  }) {
    if (value == null) return null;
    if (value.isEmpty) return null;
    if (url && !value.startsWith("https://")) return null;
    if (counterRef && !value.startsWith("#")) return null;
    if (objectRef && !value.startsWith("@")) return null;
    return value;
  }

  List<String>? verifiedStrings(
    List<String>? value, {
    bool url = false,
    bool counterRef = false,
    bool objectRef = false,
  }) {
    if (value == null) return null;
    if (value.isEmpty) return null;
    if (url && !value.every((e) => e.startsWith("https://"))) return null;
    if (counterRef && !value.every((e) => e.startsWith("#"))) return null;
    if (objectRef && !value.every((e) => e.startsWith("@"))) return null;
    return value;
  }

  String? verifiedCounterRef(String? value) {
    if (value == null) return null;
    if (value.isEmpty) return null;
    if (!value.startsWith("#")) return null;
    return value;
  }

  String? verifiedObjectRef(String? value) {
    if (value == null) return null;
    if (value.isEmpty) return null;
    if (!value.startsWith("@")) return null;
    return value;
  }
}
