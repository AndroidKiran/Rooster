// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'device_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DeviceInfo _$DeviceInfoFromJson(Map<String, dynamic> json) => DeviceInfo(
      fcmToken: json['fcmToken'] as String,
      os: json['os'] as String,
      createdAt: const ServerTimestampToMilliSecondConverter()
          .fromJson(json['createdAt']),
      modifiedAt: const ServerTimestampToMilliSecondConverter()
          .fromJson(json['modifiedAt']),
    );

Map<String, dynamic> _$DeviceInfoToJson(DeviceInfo instance) =>
    <String, dynamic>{
      'fcmToken': instance.fcmToken,
      'os': instance.os,
      'createdAt': const ServerTimestampToMilliSecondConverter()
          .toJson(instance.createdAt),
      'modifiedAt': const ServerTimestampToMilliSecondConverter()
          .toJson(instance.modifiedAt),
    };
