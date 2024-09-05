part of 'issue_bloc.dart';

/// Defines the possible states of issue operations.
enum Status {
  init,
  loading,
  success,
  failure;
}

/// Represents the state of an issue within the BLoC.
///
/// This immutable class encapsulates the current status of issue
/// operations and the issue information itself, providing a structured
/// way to track issue data within a BLoC.
@immutable
final class IssueState extends Equatable {
  final Status status;
  final FirestoreIssueInfo firestoreIssueInfo;

  const IssueState._(
      {this.status = Status.init,
      this.firestoreIssueInfo = FirestoreIssueInfo.emptyInstance});

  const IssueState.init() : this._();

  const IssueState.loading()
      : this._(
            status: Status.loading,
            firestoreIssueInfo: FirestoreIssueInfo.emptyInstance);

  const IssueState.success(FirestoreIssueInfo firestoreIssueInfo)
      : this._(status: Status.success, firestoreIssueInfo: firestoreIssueInfo);

  const IssueState.failure()
      : this._(
            status: Status.failure,
            firestoreIssueInfo: FirestoreIssueInfo.emptyInstance);

  @override
  List<Object?> get props => [status, firestoreIssueInfo];
}
