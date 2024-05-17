import 'dart:developer';

import 'package:rooster/data_stores/entities/firestore_entities/firestore_issue_info.dart';
import 'package:rooster/data_stores/entities/firestore_entities/firestore_user_info.dart';
import 'package:rooster/data_stores/repositories/issue_repo/issue_repository.dart';
import 'package:rooster/helpers/firebase_manager.dart';
import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';

class IssueRepositoryImplementation implements IssueRepository {
  final StreamingSharedPreferences _preferences;
  final _issueDb = FirebaseManager().issueDb;

  IssueRepositoryImplementation(
      {required StreamingSharedPreferences preferences})
      : _preferences = preferences;

  @override
  Future<String> getIssueId() async {
    return _preferences.getString(ISSUE_ID, defaultValue: '').getValue();
  }

  @override
  Future<void> saveIssueId(String crashId) async {
    await _preferences.setString(ISSUE_ID, crashId);
  }

  @override
  Future<FirestoreIssueInfo> getFireStoreIssue(String issueId) async {
    FirestoreIssueInfo issueInfo = FirestoreIssueInfo.emptyInstance;
    try {
      final docSnapShot = await _issueDb.doc(issueId).get();
      if (docSnapShot.exists) {
        issueInfo = docSnapShot.data() ?? FirestoreIssueInfo.emptyInstance;
      }
    } catch (e) {
      log(e.toString());
    }
    return issueInfo;
  }

  @override
  Future<void> updateFireStoreIssueVisit(FirestoreIssueInfo firestoreIssueInfo,
      FirestoreUserInfo firestoreUserInfo) async {
    try {
      await _issueDb.doc(firestoreIssueInfo.id).update({
        'visitedUserId': firestoreUserInfo.id,
        'modifiedAt': firestoreIssueInfo.entity.modifiedAt
      });
    } catch (e) {
      log(e.toString());
    }
  }

  static const String ISSUE_ID = "issue_id";
}
