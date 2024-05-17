// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'issue_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

IssueInfo _$IssueInfoFromJson(Map<String, dynamic> json) => IssueInfo(
      type: json['type'] as String,
      crashCount: json['crashCount'] as int,
      crashPercentage: json['crashPercentage'] as int,
      firstVersion: json['firstVersion'] as String,
      appVersion: json['appVersion'] as String,
      issueId: json['issueId'] as String,
      subtitle: json['subtitle'] as String,
      title: json['title'] as String,
      projectName: json['projectName'] as String,
      platform: json['platform'] as String,
      appId: json['appId'] as String,
      visitedUserId: json['visitedUserId'] as String,
      createdAt: json['createdAt'] as int?,
      modifiedAt: json['modifiedAt'] as int?,
    );

Map<String, dynamic> _$IssueInfoToJson(IssueInfo instance) => <String, dynamic>{
      'type': instance.type,
      'crashCount': instance.crashCount,
      'crashPercentage': instance.crashPercentage,
      'firstVersion': instance.firstVersion,
      'appVersion': instance.appVersion,
      'issueId': instance.issueId,
      'subtitle': instance.subtitle,
      'title': instance.title,
      'projectName': instance.projectName,
      'platform': instance.platform,
      'appId': instance.appId,
      'visitedUserId': instance.visitedUserId,
      'createdAt': instance.createdAt,
      'modifiedAt': instance.modifiedAt,
    };
