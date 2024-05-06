// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'firestore_user_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FirestoreUserInfo _$FirestoreUserInfoFromJson(Map<String, dynamic> json) =>
    FirestoreUserInfo(
      id: json['id'] as String,
      userEntity: UserInfo.fromJson(json['userEntity'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$FirestoreUserInfoToJson(FirestoreUserInfo instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userEntity': instance.userEntity,
    };
