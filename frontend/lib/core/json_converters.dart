import 'package:json_annotation/json_annotation.dart';

final class JsonConvertersFrom {
  const JsonConvertersFrom._();

  static DateTime? toLocalDateTime(String val) {
    return DateTime.tryParse(val)?.toLocal();
  }
}

final class JsonConvertersTo {
  const JsonConvertersTo._();
}

class EpochDateTimeConverter implements JsonConverter<DateTime, int> {
  const EpochDateTimeConverter();

  @override
  DateTime fromJson(int json) => DateTime.fromMillisecondsSinceEpoch(json);

  @override
  int toJson(DateTime object) => object.millisecondsSinceEpoch;
}
