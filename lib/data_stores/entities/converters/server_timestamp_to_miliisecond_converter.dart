import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';

/// Handles the conversion between Firestore timestamps (`Timestamp` objects)
/// and integer values representing milliseconds since the epoch.
///
/// This converter is useful when working with Firestore data that involves
/// timestamps, as it allows you to easily store and retrieve timestamps in a
/// format that's convenient for your application.

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
