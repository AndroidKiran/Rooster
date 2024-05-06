import 'package:rooster/data_stores/entities/firestore_entities/firestore_issue_info.dart';
import 'package:rooster/data_stores/entities/issue_info.dart';

abstract class IssueRepository {
  Future<void> saveIssueId(String crashId);

  Future<String> getIssueId();

  Future<FirestoreIssueInfo> getFireStoreIssue(String issueId);
}
