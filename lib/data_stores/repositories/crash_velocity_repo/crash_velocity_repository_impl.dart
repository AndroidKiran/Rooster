import 'package:rooster/data_stores/repositories/crash_velocity_repo/crash_velocity_repository.dart';
import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';

class CrashVelocityRepositoryImplementation implements CrashVelocityRepository {
  final StreamingSharedPreferences _preferences;

  CrashVelocityRepositoryImplementation(
      {required StreamingSharedPreferences preferences})
      : _preferences = preferences;

  @override
  Future<String> getCrashId() async {
    return _preferences
        .getString(CRASH_VELOCITY_ID, defaultValue: '')
        .getValue();
  }

  @override
  Future<void> saveCrashId(String crashId) async {
    await _preferences.setString(CRASH_VELOCITY_ID, crashId);
  }

  static const String CRASH_VELOCITY_ID = "crash_velocity_id";
}
