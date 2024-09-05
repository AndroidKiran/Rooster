import 'package:rooster/data_stores/entities/firestore_entities/firestore_issue_info.dart';
import 'package:rooster/data_stores/entities/firestore_entities/firestore_user_info.dart';

/// An abstract class that defines the interface for interacting with
/// issue data.
///
/// This class outlines a set of methods that any concrete implementation
/// of this repository must provide, ensuring consistency and
/// maintainability when working with issue data.

abstract class IssueRepository {
  Future<void> saveIssueId(String crashId);

  Future<String> getIssueId();

  Future<FirestoreIssueInfo> getFireStoreIssue(String issueId);

  Future<void> updateFireStoreIssueVisit(FirestoreIssueInfo firestoreIssueInfo,
      FirestoreUserInfo firestoreUserInfo);
}
