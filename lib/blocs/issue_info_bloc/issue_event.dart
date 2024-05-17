part of 'issue_bloc.dart';

@immutable
sealed class IssueEvent extends Equatable {}

final class FetchIssueInfoEvent extends IssueEvent {
  final String issueId;

  FetchIssueInfoEvent({required this.issueId});

  @override
  List<Object?> get props => [issueId];
}

final class UpdateIssueInfoEvent extends IssueEvent {
  final FirestoreIssueInfo firestoreIssueInfo;
  final FirestoreUserInfo firestoreUserInfo;

  UpdateIssueInfoEvent(
      {required this.firestoreIssueInfo, required this.firestoreUserInfo});

  @override
  List<Object?> get props => [firestoreIssueInfo, firestoreUserInfo];
}
