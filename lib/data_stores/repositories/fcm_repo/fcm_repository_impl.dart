import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:rooster/data_stores/repositories/fcm_repo/fcm_repository.dart';
import 'package:rooster/helpers/firebase_manager.dart';
import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';

class FcmRepositoryImplementation implements FcmRepository {
  final StreamingSharedPreferences _preferences;
  final _firebaseMessaging = FirebaseManager().firebaseMessaging;

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
}
