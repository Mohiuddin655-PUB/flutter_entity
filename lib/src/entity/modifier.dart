class Modifier<T extends Object> {
  final bool isNull;
  final T? value;

  const Modifier.nullable()
      : value = null,
        isNull = true;

  const Modifier(this.value) : isNull = false;

  T? modify({
    bool boolCheck = true,
    bool numCheck = true,
    bool stringCheck = true,
    bool mapCheck = true,
    bool listCheck = true,
    T? old,
  }) {
    if (isNull) return null;

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
