class EntityTimestamp {
  final DateTime? dateTimeOrNull;

  const EntityTimestamp() : dateTimeOrNull = null;

  const EntityTimestamp._(this.dateTimeOrNull);

  EntityTimestamp.now() : dateTimeOrNull = DateTime.now();

  factory EntityTimestamp.fromDateTime(DateTime dateTime) {
    return EntityTimestamp._(dateTime);
  }

  bool get isEmpty => dateTimeOrNull == null;

  DateTime get dateTime => dateTimeOrNull ?? DateTime.now();

  DateTime get normalized {
    final date = dateTime;
    return DateTime(date.year, date.month, date.day);
  }

  static EntityTimestamp? tryParse(Object? source) {
    if (source is EntityTimestamp) return source;
    if (source is DateTime) return EntityTimestamp._(source);

    if (source is String) {
      final parsed = DateTime.tryParse(source);
      if (parsed != null) return EntityTimestamp._(parsed);
      return null;
    }

    if (source is num && source > 0) {
      return EntityTimestamp._(
        DateTime.fromMillisecondsSinceEpoch(source.toInt()),
      );
    }

    return null;
  }

  static EntityTimestamp parse(Object? source) {
    return tryParse(source) ?? const EntityTimestamp();
  }

  @override
  int get hashCode => dateTimeOrNull.hashCode;

  @override
  bool operator ==(Object other) {
    return other is EntityTimestamp && other.dateTimeOrNull == dateTimeOrNull;
  }

  @override
  String toString() => "$EntityTimestamp($dateTimeOrNull)";
}
