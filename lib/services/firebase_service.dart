import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:rooster/data_stores/repositories/user_repo/user_repository.dart';
import 'package:uuid/uuid.dart';

import '../data_stores/repositories/crash_velocity_repo/crash_velocity_repository.dart';
import 'call_kit_service.dart';

class FirebaseService {
  // static final FirebaseFirestore firebaseFireStore = FirebaseFirestore.instance;
  // static final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;

  // final UserRepository userRepository;
  // final CrashVelocityRepository crashVelocityRepository;

  static Future<void> setupFirebase() async {
    // FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
    //   log('Message title: ${message.notification?.title}, body: ${message.notification?.body}, data: ${message.data}');
    //
    //   if (!isVelocityAlertNotification(message)) return;
    //
    //   final user = await userRepository.getUserFromPreference();
    //   if (user.isEmptyInstance()) return;
    //
    //   final String? crashId = message.data['crash_id'];
    //   if (crashId == null || crashId.isEmpty) return;
    //   crashVelocityRepository.saveCrashId(crashId);
    //
    //   CallKitService.showCallkitIncoming(const Uuid().v4());
    // });
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
