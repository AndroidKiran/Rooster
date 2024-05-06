part of 'issue_bloc.dart';

@immutable
sealed class IssueEvent extends Equatable {}

final class FetchIssueInfoEvent extends IssueEvent {
  final String issueId;

  FetchIssueInfoEvent({required this.issueId});

  @override
  List<Object?> get props => [issueId];
}
