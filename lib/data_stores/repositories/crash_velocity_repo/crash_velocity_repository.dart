abstract class CrashVelocityRepository {
  Future<void> saveCrashId(String crashId);

  Future<String> getCrashId();
}
