import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:rooster/utils/rooster_platform.dart';

import 'converters/server_timestamp_converter.dart';

part 'device_info.g.dart';

@JsonSerializable()
@ServerTimestampConverter()
class DeviceInfo extends Equatable {
  final String fcmToken;
  final String os;
  final DateTime? createdAt;
  final DateTime? modifiedAt;

  const DeviceInfo(
      {required this.fcmToken,
      required this.os,
      required this.createdAt,
      required this.modifiedAt});

  DeviceInfo copyWith(
      {String? fcmToken,
      String? os,
      DateTime? createdAt,
      DateTime? modifiedAt}) {
    return DeviceInfo(
        fcmToken: fcmToken ?? this.fcmToken,
        os: os ?? this.os,
        createdAt: createdAt ?? this.createdAt,
        modifiedAt: modifiedAt ?? this.modifiedAt);
  }

  factory DeviceInfo.fromJson(Map<String, dynamic> json) =>
      _$DeviceInfoFromJson(json);

  Map<String, dynamic> toJson() => _$DeviceInfoToJson(this);

  static DeviceInfo newTokenDeviceInfo(String token) => DeviceInfo(
      fcmToken: token,
      os: RoosterPlatform.getDeviceOs(),
      createdAt: DateTime.now(),
      modifiedAt: DateTime.now());

  @override
  List<Object?> get props => [fcmToken, os, createdAt, modifiedAt];
}
