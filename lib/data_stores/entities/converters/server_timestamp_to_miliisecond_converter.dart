import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';

class ServerTimestampToMilliSecondConverter
    implements JsonConverter<int?, Object?> {
  const ServerTimestampToMilliSecondConverter();

  @override
  int? fromJson(Object? timestamp) {
    if (timestamp is Timestamp) {
      return timestamp.millisecondsSinceEpoch;
    } else {
      return Timestamp.now().millisecondsSinceEpoch;
    }
  }

  @override
  Object? toJson(int? dateTime) =>
      dateTime != null ? Timestamp.fromMillisecondsSinceEpoch(dateTime) : null;
}
