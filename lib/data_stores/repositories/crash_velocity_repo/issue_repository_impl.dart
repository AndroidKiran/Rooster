import 'package:rooster/data_stores/repositories/crash_velocity_repo/issue_repository.dart';
import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';

class IssueRepositoryImplementation implements IssueRepository {
  final StreamingSharedPreferences _preferences;

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

  static const String ISSUE_ID = "issue_id";
}
