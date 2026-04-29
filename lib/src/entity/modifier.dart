/// A wrapper that distinguishes "set this value" from "leave unchanged" and
/// "explicitly set to null" — safer than nullable parameters for `update()`-
/// style APIs.
///
/// Usage:
/// - `Modifier(x)` — set to `x` (including `false`, `0`, `""`, empty maps).
/// - `Modifier.nullable()` — explicitly clear the field to `null`.
/// - Pass `null` (omit the parameter) — leave the field unchanged.
class Modifier<T extends Object> {
  final bool isNull;
  final T? value;

  /// Explicitly clears the field to `null`.
  const Modifier.nullable() : value = null, isNull = true;

  /// Sets the field to [value]. `false`, `0`, empty strings/maps/lists are
  /// treated as valid values, not as "no value".
  const Modifier(this.value) : isNull = false;

  /// Resolves this modifier against an existing [old] value.
  ///
  /// - If this is [Modifier.nullable], returns `null`.
  /// - If [value] is non-null, returns it.
  /// - Otherwise returns [old].
  T? modify({T? old}) {
    if (isNull) return null;
    return value ?? old;
  }
}
