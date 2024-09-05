import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'issue_info.g.dart';

/// Represents information about an issue, related to crashes or
/// errors in an application.
///
/// This class provides methods for JSON serialization, value comparison,
/// generating relevant URLs, and providing descriptive messages about
/// the issue.

@JsonSerializable()
class IssueInfo extends Equatable {
  final String type;
  final int crashCount;
  final int crashPercentage;
  final String firstVersion;
  final String appVersion;
  final String issueId;
  final String subtitle;
  final String title;
  final String projectName;
  final String platform;
  final String appId;
  final String visitedUserId;
  final int? createdAt;
  final int? modifiedAt;

  const IssueInfo({
    required this.type,
    required this.crashCount,
    required this.crashPercentage,
    required this.firstVersion,
    required this.appVersion,
    required this.issueId,
    required this.subtitle,
    required this.title,
    required this.projectName,
    required this.platform,
    required this.appId,
    required this.visitedUserId,
    required this.createdAt,
    required this.modifiedAt,
  });

  factory IssueInfo.fromJson(Map<String, dynamic> json) =>
      _$IssueInfoFromJson(json);

  Map<String, dynamic> toJson() => _$IssueInfoToJson(this);

  String getCrashlyticsIssueUrl() =>
      'https://console.firebase.google.com/u/0/project/$projectName/crashlytics/app/$platform:$appId/issues/$issueId';

  static const emptyInstance = IssueInfo(
    type: '',
    crashCount: 0,
    crashPercentage: 0,
    firstVersion: '',
    appVersion: '',
    issueId: '',
    subtitle: '',
    title: '',
    projectName: '',
    platform: '',
    appId: '',
    visitedUserId: '',
    createdAt: null,
    modifiedAt: null,
  );

  bool isEmptyInstance() {
    return this == emptyInstance;
  }

  String getScreenTitle() {
    var title = 'Alert';
    if (type.contains(TYPE_STABILITY_DIGEST)) {
      title = 'Stability Alert';
    } else if (type.contains(TYPE_VELOCITY_ALERT)) {
      title = 'Velocity Alert';
    }
    return title;
  }

  String getIssueMsg() {
    return 'Crashes are spiking for an issue in version $appVersion in the last hour.';
  }

  String getFirstSeenMsg() {
    return 'The issue was first seen in version $firstVersion.';
  }

  @override
  List<Object?> get props => [
        type,
        crashCount,
        crashPercentage,
        firstVersion,
        appVersion,
        issueId,
        subtitle,
        title,
        projectName,
        platform,
        appId,
        visitedUserId,
        createdAt,
        modifiedAt
      ];

  static String TYPE_STABILITY_DIGEST = 'CrashlyticsStabilityDigestPayload';
  static String TYPE_VELOCITY_ALERT = 'CrashlyticsVelocityAlertPayload';
}
