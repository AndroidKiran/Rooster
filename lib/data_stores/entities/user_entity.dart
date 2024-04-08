import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

import 'converters/server_timestamp_converter.dart';

part 'user_entity.g.dart';

@JsonSerializable()
@ServerTimestampConverter()
class UserEntity extends Equatable {
  final String email;
  final String name;
  final String platform;
  final String deviceInfoRef;
  final bool isOnCall;
  final DateTime? createdAt;
  final DateTime? modifiedAt;

  const UserEntity(
      {required this.email,
      required this.name,
      required this.platform,
      required this.deviceInfoRef,
      required this.isOnCall,
      required this.createdAt,
      required this.modifiedAt});

  bool isEmptyInstance() {
    return this == emptyInstance;
  }

  UserEntity copyWith(
      {String? userId,
      String? email,
      String? name,
      String? platform,
      String? deviceInfoRef,
      bool? isOnCall,
      DateTime? createdAt,
      DateTime? modifiedAt}) {
    return UserEntity(
        email: email ?? this.email,
        name: name ?? this.name,
        platform: platform ?? this.platform,
        deviceInfoRef: deviceInfoRef ?? this.deviceInfoRef,
        isOnCall: isOnCall ?? this.isOnCall,
        createdAt: createdAt ?? this.createdAt,
        modifiedAt: modifiedAt ?? this.modifiedAt);
  }

  factory UserEntity.fromJson(Map<String, dynamic> json) =>
      _$UserEntityFromJson(json);

  Map<String, dynamic> toJson() => _$UserEntityToJson(this);

  static const emptyInstance = UserEntity(
    email: '',
    name: '',
    platform: '',
    deviceInfoRef: '',
    isOnCall: false,
    createdAt: null,
    modifiedAt: null,
  );

  @override
  List<Object?> get props =>
      [email, name, platform, deviceInfoRef, isOnCall, createdAt, modifiedAt];
}
