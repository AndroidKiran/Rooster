// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'device_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DeviceInfo _$DeviceInfoFromJson(Map<String, dynamic> json) => DeviceInfo(
      fcmToken: json['fcmToken'] as String,
      os: json['os'] as String,
      createdAt: const ServerTimestampConverter().fromJson(json['createdAt']),
      modifiedAt: const ServerTimestampConverter().fromJson(json['modifiedAt']),
    );

Map<String, dynamic> _$DeviceInfoToJson(DeviceInfo instance) =>
    <String, dynamic>{
      'fcmToken': instance.fcmToken,
      'os': instance.os,
      'createdAt': const ServerTimestampConverter().toJson(instance.createdAt),
      'modifiedAt':
          const ServerTimestampConverter().toJson(instance.modifiedAt),
    };
