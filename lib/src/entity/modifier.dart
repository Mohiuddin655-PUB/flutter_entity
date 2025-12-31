class Modifier<T extends Object> {
  final bool isUnset;
  final T? value;

  static const Modifier unset = Modifier._(null, true);

  const Modifier._(this.value, this.isUnset);

  const Modifier(this.value) : isUnset = false;

  T? modify({
    bool boolCheck = true,
    bool numCheck = true,
    bool stringCheck = true,
    bool mapCheck = true,
    bool listCheck = true,
    T? old,
  }) {
    if (isUnset) return null;

    if (old == null && value == null) return null;

    T? check(T? v) {
      if (v == null) return null;
      if (boolCheck && v is bool && !v) return null;
      if (numCheck && v is num && v == 0) return null;
      if (stringCheck && v is String && v.isEmpty) return null;
      if (mapCheck && v is Map && v.isEmpty) return null;
      if (listCheck && v is List && v.isEmpty) return null;
      return v;
    }

    if (old == null) return check(old);

    return check(value) ?? check(old);
  }
}
