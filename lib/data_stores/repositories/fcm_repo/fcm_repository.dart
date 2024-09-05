import 'package:firebase_messaging/firebase_messaging.dart';

/// An abstract class that defines the interface for interacting with
/// Firebase Cloud Messaging (FCM).
///
/// This class outlines a set of methods that any concrete implementation
/// of this repository must provide, ensuring consistency and
/// maintainability when working with FCM.

abstract class FcmRepository {
  Stream<RemoteMessage> get messageForegroundState;

  Stream<RemoteMessage> get messageBackgroundState;

  Stream<String> get refreshToken;

  Future<String?> getFcmToken();
}
