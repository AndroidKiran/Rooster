// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'firestore_device_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FirestoreDeviceInfo _$FirestoreDeviceInfoFromJson(Map<String, dynamic> json) =>
    FirestoreDeviceInfo(
      id: json['id'] as String,
      deviceInfo:
          DeviceInfo.fromJson(json['deviceInfo'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$FirestoreDeviceInfoToJson(
        FirestoreDeviceInfo instance) =>
    <String, dynamic>{
      'id': instance.id,
      'deviceInfo': instance.deviceInfo,
    };
