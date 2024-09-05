part of 'issue_bloc.dart';

/// A sealed class representing events that can trigger state changes
/// in the issue BLoC.
@immutable
sealed class IssueEvent extends Equatable {}

/// Event signaling a request to fetch issue information.
final class FetchIssueInfoEvent extends IssueEvent {
  final String issueId;

  FetchIssueInfoEvent({required this.issueId});

  @override
  List<Object?> get props => [issueId];
}

/// Event signaling a request to update issue information.
final class UpdateIssueInfoEvent extends IssueEvent {
  final FirestoreIssueInfo firestoreIssueInfo;
  final FirestoreUserInfo firestoreUserInfo;

  UpdateIssueInfoEvent(
      {required this.firestoreIssueInfo, required this.firestoreUserInfo});

  @override
  List<Object?> get props => [firestoreIssueInfo, firestoreUserInfo];
}
