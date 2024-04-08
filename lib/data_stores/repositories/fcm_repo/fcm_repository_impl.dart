import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:rooster/data_stores/repositories/fcm_repo/fcm_repository.dart';
import 'package:rooster/services/firebase_service.dart';
import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';

class FcmRepositoryImplementation implements FcmRepository {
  final StreamingSharedPreferences _preferences;
  final _firebaseMessaging = FirebaseService.roosterFirebaseMessaging();

  FcmRepositoryImplementation({required StreamingSharedPreferences preferences})
      : _preferences = preferences;

  @override
  Stream<RemoteMessage> get messageForegroundState {
    return FirebaseMessaging.onMessage.map((remoteMessage) => remoteMessage);
  }

  @override
  Stream<RemoteMessage> get messageBackgroundState {
    return FirebaseMessaging.onMessageOpenedApp
        .map((remoteMessage) => remoteMessage);
  }

  @override
  Stream<String> get refreshToken {
    return _firebaseMessaging.onTokenRefresh
        .map((refreshToken) => refreshToken);
  }

  @override
  Future<String?> getFcmToken() => _firebaseMessaging.getToken();

  @override
  Future<bool> isRefreshTokenSyncCompleted() async {
    return await _preferences
        .getBool(REFRESH_TOKEN_COMPLETED, defaultValue: false)
        .getValue();
  }

  @override
  Future<void> setRefreshTokenSyncState(bool completed) async {
    await _preferences.setBool(REFRESH_TOKEN_COMPLETED, completed);
  }

  static const REFRESH_TOKEN_COMPLETED = "refresh_token_completed";
}
