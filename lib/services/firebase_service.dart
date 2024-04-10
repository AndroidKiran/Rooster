import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class FirebaseService {
  static Future<void> setupFirebase() async {
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: false,
      sound: true,
    );
  }

  static FirebaseFirestore roosterFireStore() {
    FirebaseFirestore firebaseFireStore = FirebaseFirestore.instance;
    firebaseFireStore.settings = const Settings(
      persistenceEnabled: true,
      cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
    );
    return firebaseFireStore;
  }

  static FirebaseMessaging roosterFirebaseMessaging() {
    return FirebaseMessaging.instance;
  }

  static bool isVelocityAlertNotification(RemoteMessage message) {
    return message.data.containsKey(CRASH_VELOCITY_NOTIFICATION_TYPE);
  }

  static const String CRASH_VELOCITY_NOTIFICATION_TYPE =
      "crash_velocity_notification_type";
}
