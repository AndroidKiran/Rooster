import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:rooster/data_stores/entities/converters/server_timestamp_to_miliisecond_converter.dart';
import 'package:rooster/utils/string_extensions.dart';

part 'user_info.g.dart';

/// Represents user information, including details like email, name,
/// platform, device info reference, and on-call status.
/// This class provides methods for JSON serialization, value comparison,
/// and extracting relevant details from the user data.

@JsonSerializable()
@ServerTimestampToMilliSecondConverter()
class UserInfo extends Equatable {
  final String email;
  final String name;
  final String platform;
  final String deviceInfoRef;
  final bool isOnCall;
  final bool isAdmin;
  final int? createdAt;
  final int? modifiedAt;

  const UserInfo(
      {required this.email,
      required this.name,
      required this.platform,
      required this.deviceInfoRef,
      required this.isOnCall,
      required this.isAdmin,
      required this.createdAt,
      required this.modifiedAt});

  bool isEmptyInstance() {
    return this == emptyInstance;
  }

  UserInfo copyWith(
      {String? email,
      String? name,
      String? platform,
      String? deviceInfoRef,
      bool? isOnCall,
      bool? isAdmin,
      int? createdAt,
      int? modifiedAt}) {
    return UserInfo(
        email: email ?? this.email,
        name: name ?? this.name,
        platform: platform ?? this.platform,
        deviceInfoRef: deviceInfoRef ?? this.deviceInfoRef,
        isOnCall: isOnCall ?? this.isOnCall,
        isAdmin: isAdmin ?? this.isAdmin,
        createdAt: createdAt ?? this.createdAt,
        modifiedAt: modifiedAt ?? this.modifiedAt);
  }

  factory UserInfo.fromJson(Map<String, dynamic> json) =>
      _$UserInfoFromJson(json);

  Map<String, dynamic> toJson() => _$UserInfoToJson(this);

  Map<String, dynamic> toPreferenceJson() => {
        'email': email,
        'name': name,
        'platform': platform,
        'deviceInfoRef': deviceInfoRef,
        'isOnCall': isOnCall,
        'isAdmin': isAdmin,
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

  String getDeviceInfoDocId() {
    var docId = '';
    try {
      final List<String> pathList = deviceInfoRef.split("/");
      if (pathList.isNotEmpty && pathList.length >= 2) {
        docId = pathList[1];
      }
    } catch (e) {
      log(e.toString());
    }
    return docId;
  }

  String getOnCallText() {
    var enableOnCall = 'Enable on call';
    if (isOnCall) {
      enableOnCall = 'Disable on call';
    }
    return enableOnCall;
  }

  static UserInfo fromPreferenceJson(Map<String, dynamic> doc) {
    if (doc.isEmpty) return emptyInstance;
    return UserInfo(
      email: doc['email'],
      name: doc['name'],
      platform: doc['platform'],
      deviceInfoRef: doc['deviceInfoRef'],
      isOnCall: doc['isOnCall'],
      isAdmin: doc['isAdmin'],
      createdAt: doc['createdAt'],
      modifiedAt: doc['modifiedAt'],
    );
  }

  static const emptyInstance = UserInfo(
    email: '',
    name: '',
    platform: '',
    deviceInfoRef: '',
    isOnCall: false,
    isAdmin: false,
    createdAt: null,
    modifiedAt: null,
  );

  @override
  List<Object?> get props => [
        email,
        name,
        platform,
        deviceInfoRef,
        isOnCall,
        isAdmin,
        createdAt,
        modifiedAt
      ];
}
