import 'package:firebase_messaging/firebase_messaging.dart';

abstract class FcmRepository {
  Stream<RemoteMessage> get messageForegroundState;

  Stream<RemoteMessage> get messageBackgroundState;

  Stream<String> get refreshToken;

  Future<String?> getFcmToken();

// Future<bool> isRefreshTokenSyncRequired();
//
// Future<void> setRefreshTokenSyncState(bool completed);
}
