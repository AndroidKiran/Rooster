// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'crash_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CrashInfo _$CrashInfoFromJson(Map<String, dynamic> json) => CrashInfo(
      type: json['type'] as String,
      crashCount: json['crashCount'] as int,
      crashPercentage: json['crashPercentage'] as int,
      createTime: json['createTime'] as String,
      firstVersion: json['firstVersion'] as String,
      appVersion: json['appVersion'] as String,
      issueId: json['issueId'] as String,
      subtitle: json['subtitle'] as String,
      title: json['title'] as String,
      projectName: json['projectName'] as String,
      platform: json['platform'] as String,
      appId: json['appId'] as String,
    );

Map<String, dynamic> _$CrashInfoToJson(CrashInfo instance) => <String, dynamic>{
      'type': instance.type,
      'crashCount': instance.crashCount,
      'crashPercentage': instance.crashPercentage,
      'createTime': instance.createTime,
      'firstVersion': instance.firstVersion,
      'appVersion': instance.appVersion,
      'issueId': instance.issueId,
      'subtitle': instance.subtitle,
      'title': instance.title,
      'projectName': instance.projectName,
      'platform': instance.platform,
      'appId': instance.appId,
    };
