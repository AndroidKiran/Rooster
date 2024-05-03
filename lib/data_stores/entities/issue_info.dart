import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'issue_info.g.dart';

@JsonSerializable()
class IssueInfo extends Equatable {
  final String type;
  final int crashCount;
  final int crashPercentage;
  final String createTime;
  final String firstVersion;
  final String appVersion;
  final String issueId;
  final String subtitle;
  final String title;
  final String projectName;
  final String platform;
  final String appId;

  const IssueInfo(
      {required this.type,
      required this.crashCount,
      required this.crashPercentage,
      required this.createTime,
      required this.firstVersion,
      required this.appVersion,
      required this.issueId,
      required this.subtitle,
      required this.title,
      required this.projectName,
      required this.platform,
      required this.appId});

  factory IssueInfo.fromJson(Map<String, dynamic> json) =>
      _$IssueInfoFromJson(json);

  Map<String, dynamic> toJson() => _$IssueInfoToJson(this);

  String getCrashlyticsIssueUrl() =>
      'https://console.firebase.google.com/u/0/project/$projectName/crashlytics/app/$platform:$appId/issues/$issueId';

  static const emptyInstance = IssueInfo(
      type: '',
      crashCount: 0,
      crashPercentage: 0,
      createTime: '',
      firstVersion: '',
      appVersion: '',
      issueId: '',
      subtitle: '',
      title: '',
      projectName: '',
      platform: '',
      appId: '');

  @override
  List<Object?> get props => [
        type,
        crashCount,
        crashPercentage,
        createTime,
        firstVersion,
        appVersion,
        issueId,
        subtitle,
        title,
        projectName
      ];
}
