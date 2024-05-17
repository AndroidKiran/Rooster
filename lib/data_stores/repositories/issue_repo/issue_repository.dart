import 'package:rooster/data_stores/entities/firestore_entities/firestore_issue_info.dart';
import 'package:rooster/data_stores/entities/firestore_entities/firestore_user_info.dart';

abstract class IssueRepository {
  Future<void> saveIssueId(String crashId);

  Future<String> getIssueId();

  Future<FirestoreIssueInfo> getFireStoreIssue(String issueId);

  Future<void> updateFireStoreIssueVisit(FirestoreIssueInfo firestoreIssueInfo,
      FirestoreUserInfo firestoreUserInfo);
}
