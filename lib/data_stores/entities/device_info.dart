import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:rooster/data_stores/entities/converters/server_timestamp_to_miliisecond_converter.dart';
import 'package:rooster/utils/rooster_platform.dart';

part 'device_info.g.dart';

@JsonSerializable()
@ServerTimestampToMilliSecondConverter()
class DeviceInfo extends Equatable {
  final String fcmToken;
  final String os;
  final int? createdAt;
  final int? modifiedAt;

  const DeviceInfo(
      {required this.fcmToken,
      required this.os,
      required this.createdAt,
      required this.modifiedAt});

  DeviceInfo copyWith(
      {String? fcmToken, String? os, int? createdAt, int? modifiedAt}) {
    return DeviceInfo(
        fcmToken: fcmToken ?? this.fcmToken,
        os: os ?? this.os,
        createdAt: createdAt ?? this.createdAt,
        modifiedAt: modifiedAt ?? this.modifiedAt);
  }

  factory DeviceInfo.fromJson(Map<String, dynamic> json) =>
      _$DeviceInfoFromJson(json);

  Map<String, dynamic> toJson() => _$DeviceInfoToJson(this);

  static const emptyInstance =
      DeviceInfo(fcmToken: '', os: '', createdAt: null, modifiedAt: null);

  bool isEmptyInstance() {
    return this == emptyInstance;
  }

  static DeviceInfo newTokenDeviceInfo(String token) => DeviceInfo(
      fcmToken: token,
      os: RoosterPlatform.getDeviceOs(),
      createdAt: DateTime.now().millisecondsSinceEpoch,
      modifiedAt: DateTime.now().millisecondsSinceEpoch);

  @override
  List<Object?> get props => [fcmToken, os, createdAt, modifiedAt];
}
