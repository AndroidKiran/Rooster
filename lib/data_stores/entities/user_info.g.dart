// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserInfo _$UserInfoFromJson(Map<String, dynamic> json) => UserInfo(
      email: json['email'] as String,
      name: json['name'] as String,
      platform: json['platform'] as String,
      deviceInfoRef: json['deviceInfoRef'] as String,
      isOnCall: json['isOnCall'] as bool,
      isAdmin: json['isAdmin'] as bool,
      createdAt: const ServerTimestampToMilliSecondConverter()
          .fromJson(json['createdAt']),
      modifiedAt: const ServerTimestampToMilliSecondConverter()
          .fromJson(json['modifiedAt']),
    );

Map<String, dynamic> _$UserInfoToJson(UserInfo instance) => <String, dynamic>{
      'email': instance.email,
      'name': instance.name,
      'platform': instance.platform,
      'deviceInfoRef': instance.deviceInfoRef,
      'isOnCall': instance.isOnCall,
      'isAdmin': instance.isAdmin,
      'createdAt': const ServerTimestampToMilliSecondConverter()
          .toJson(instance.createdAt),
      'modifiedAt': const ServerTimestampToMilliSecondConverter()
          .toJson(instance.modifiedAt),
    };
