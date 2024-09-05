import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:rooster/data_stores/entities/firestore_entities/firestore_issue_info.dart';
import 'package:rooster/data_stores/entities/firestore_entities/firestore_user_info.dart';
import 'package:rooster/data_stores/repositories/issue_repo/issue_repository.dart';

part 'issue_event.dart';

part 'issue_state.dart';

/// A BLoC (Business Logic Component) that manages the state of issues
/// in a Flutter application.
///
/// This BLoC fetches issue information, handles issue updates, and
/// emits corresponding states to update the UI accordingly.

class IssueBloc extends Bloc<IssueEvent, IssueState> {
  final IssueRepository _issueRepository;

  IssueBloc({required IssueRepository issueRepository})
      : _issueRepository = issueRepository,
        super(const IssueState.init()) {
    on<FetchIssueInfoEvent>(_onFetchDetailsEvent);
    on<UpdateIssueInfoEvent>(_onUpdateIssueEvent);
  }

  Future<void> _onFetchDetailsEvent(
      FetchIssueInfoEvent event, Emitter<IssueState> emit) async {
    var state = const IssueState.loading();
    emit(state);
    final issueId = event.issueId;
    final firestoreIssueInfo =
        await _issueRepository.getFireStoreIssue(issueId);
    if (firestoreIssueInfo.isEmptyInstance()) {
      state = const IssueState.failure();
    } else {
      state = IssueState.success(firestoreIssueInfo);
    }
    emit(state);
  }

  Future<void> _onUpdateIssueEvent(
      UpdateIssueInfoEvent event, Emitter<IssueState> emit) async {
    final FirestoreUserInfo firestoreUserInfo = event.firestoreUserInfo;
    final FirestoreIssueInfo firestoreIssueInfo = event.firestoreIssueInfo;
    if (firestoreIssueInfo != FirestoreIssueInfo.emptyInstance &&
        firestoreUserInfo != FirestoreUserInfo.emptyInstance) {
      await _issueRepository.updateFireStoreIssueVisit(
          firestoreIssueInfo, firestoreUserInfo);
    }
  }
}
