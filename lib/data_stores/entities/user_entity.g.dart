// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserEntity _$UserEntityFromJson(Map<String, dynamic> json) => UserEntity(
      email: json['email'] as String,
      name: json['name'] as String,
      platform: json['platform'] as String,
      deviceInfoRef: json['deviceInfoRef'] as String,
      isOnCall: json['isOnCall'] as bool,
      createdAt: const ServerTimestampToMilliSecondConverter()
          .fromJson(json['createdAt']),
      modifiedAt: const ServerTimestampToMilliSecondConverter()
          .fromJson(json['modifiedAt']),
    );

Map<String, dynamic> _$UserEntityToJson(UserEntity instance) =>
    <String, dynamic>{
      'email': instance.email,
      'name': instance.name,
      'platform': instance.platform,
      'deviceInfoRef': instance.deviceInfoRef,
      'isOnCall': instance.isOnCall,
      'createdAt': const ServerTimestampToMilliSecondConverter()
          .toJson(instance.createdAt),
      'modifiedAt': const ServerTimestampToMilliSecondConverter()
          .toJson(instance.modifiedAt),
    };
