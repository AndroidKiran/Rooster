import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:rooster/data_stores/entities/converters/server_timestamp_to_miliisecond_converter.dart';
import 'package:rooster/utils/string_extensions.dart';

part 'user_entity.g.dart';

@JsonSerializable()
@ServerTimestampToMilliSecondConverter()
class UserEntity extends Equatable {
  final String email;
  final String name;
  final String platform;
  final String deviceInfoRef;
  final bool isOnCall;
  final int? createdAt;
  final int? modifiedAt;

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
      {String? email,
      String? name,
      String? platform,
      String? deviceInfoRef,
      bool? isOnCall,
      int? createdAt,
      int? modifiedAt}) {
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

  Map<String, dynamic> toPreferenceJson() => {
        'email': email,
        'name': name,
        'platform': platform,
        'deviceInfoRef': deviceInfoRef,
        'isOnCall': isOnCall,
        'createdAt': createdAt,
        'modifiedAt': modifiedAt
      };

  String getLetterFromUserName() {
    var userName = '';
    if (name.length >= 2) {
      userName = name.substring(0, 2);
    }

    if (userName.isEmpty && email.length >= 2) {
      userName = email.substring(0, 2);
    }
    return userName.toUpperCase();
  }

  String getUserName() {
    var userName = '';
    if (name.isNotEmpty) {
      userName = name;
    }
    if (userName.isEmpty && email.contains('@')) {
      userName = email.split('@').first;
    }
    return userName.toCapitalized();
  }

  String getAccountTag() {
    var accTagName = "";
    if (deviceInfoRef.isNotEmpty) {
      accTagName = 'Active Account';
    } else {
      accTagName = 'Inactive Account';
    }
    return accTagName;
  }

  static UserEntity fromPreferenceJson(Map<String, dynamic> doc) {
    if (doc.isEmpty) return emptyInstance;
    return UserEntity(
      email: doc['email'],
      name: doc['name'],
      platform: doc['platform'],
      deviceInfoRef: doc['deviceInfoRef'],
      isOnCall: doc['isOnCall'],
      createdAt: doc['createdAt'],
      modifiedAt: doc['modifiedAt'],
    );
  }

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
