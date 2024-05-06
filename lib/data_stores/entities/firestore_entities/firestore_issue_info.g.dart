// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'firestore_issue_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FirestoreIssueInfo _$FirestoreIssueInfoFromJson(Map<String, dynamic> json) =>
    FirestoreIssueInfo(
      id: json['id'] as String,
      issueInfo: IssueInfo.fromJson(json['issueInfo'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$FirestoreIssueInfoToJson(FirestoreIssueInfo instance) =>
    <String, dynamic>{
      'id': instance.id,
      'issueInfo': instance.issueInfo,
    };
