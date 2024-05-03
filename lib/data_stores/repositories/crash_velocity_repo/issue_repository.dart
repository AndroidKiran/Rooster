abstract class IssueRepository {
  Future<void> saveIssueId(String crashId);

  Future<String> getIssueId();
}
