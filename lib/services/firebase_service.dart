import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

class FirebaseService {
  static final _instance = FirebaseService._internal();

  late FirebaseFirestore firestore;
  late FirebaseMessaging firebaseMessaging;

  factory FirebaseService() {
    _instance.firestore = _roosterFireStore();
    _instance.firebaseMessaging = _roosterFirebaseMessaging();
    return _instance;
  }

  FirebaseService._internal();

  static Future<void> setupFirebase() async {
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: false,
      sound: true,
    );
  }

  static FirebaseFirestore _roosterFireStore() {
    FirebaseFirestore firebaseFireStore = FirebaseFirestore.instance;
    if (kDebugMode) {
      try {
        firebaseFireStore.useFirestoreEmulator('localhost', 8080);
      } catch (e) {
        print(e);
      }
    }
    firebaseFireStore.settings = const Settings(
        persistenceEnabled: true,
        cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
        sslEnabled: false);
    return firebaseFireStore;
  }

  static FirebaseMessaging _roosterFirebaseMessaging() {
    return FirebaseMessaging.instance;
  }

  static bool isVelocityAlertNotification(RemoteMessage message) {
    return message.data.containsKey(KEY_CRASH_VELOCITY_NOTIFICATION_TYPE) &&
        message.data[KEY_CRASH_VELOCITY_NOTIFICATION_TYPE] ==
            VALUE_CRASH_VELOCITY_NOTIFICATION_TYPE;
  }

  static bool hasValidIssueId(RemoteMessage message) {
    return message.data.containsKey(KEY_ISSUE_ID) &&
        message.data[KEY_ISSUE_ID] != null;
  }

  static const String VALUE_CRASH_VELOCITY_NOTIFICATION_TYPE =
      "CrashVelocityNotificationType";
  static const String KEY_CRASH_VELOCITY_NOTIFICATION_TYPE = "type";
  static const String KEY_ISSUE_ID = "issueId";
}
