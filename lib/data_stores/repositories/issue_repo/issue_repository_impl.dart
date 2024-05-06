import 'dart:developer';

import 'package:rooster/data_stores/entities/firestore_entities/firestore_issue_info.dart';
import 'package:rooster/data_stores/entities/issue_info.dart';
import 'package:rooster/data_stores/repositories/issue_repo/issue_repository.dart';
import 'package:rooster/helpers/firebase_manager.dart';
import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';

class IssueRepositoryImplementation implements IssueRepository {
  final StreamingSharedPreferences _preferences;
  final issueDb = FirebaseManager().issueDb;

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
    var issueInfo = FirestoreIssueInfo.emptyInstance;
    try {
      final docSnapShot = await issueDb.doc(issueId).get();
      if (docSnapShot.exists) {
        issueInfo = docSnapShot.data() ?? FirestoreIssueInfo.emptyInstance;
      }
    } catch (e) {
      log(e.toString());
    }
    return issueInfo;
  }

  static const String ISSUE_ID = "issue_id";
}
