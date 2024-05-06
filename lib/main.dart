import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:rooster/data_stores/repositories/device_info_repo/device_info_repository.dart';
import 'package:rooster/data_stores/repositories/device_info_repo/device_info_repository_impl.dart';
import 'package:rooster/data_stores/repositories/fcm_repo/fcm_repository.dart';
import 'package:rooster/data_stores/repositories/fcm_repo/fcm_repository_impl.dart';
import 'package:rooster/data_stores/repositories/issue_repo/issue_repository.dart';
import 'package:rooster/data_stores/repositories/issue_repo/issue_repository_impl.dart';
import 'package:rooster/data_stores/repositories/user_repo/user_repository.dart';
import 'package:rooster/data_stores/repositories/user_repo/user_repository_impl.dart';
import 'package:rooster/helpers/call_kit_manager.dart';
import 'package:rooster/helpers/firebase_manager.dart';
import 'package:rooster/rooster_bloc_observer.dart';
import 'package:rooster/rooster_app.dart';
import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:uuid/uuid.dart';
import 'firebase_options.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    FirebaseManager firebaseManager = FirebaseManager();
    if (!firebaseManager.isIssueNotification(message) ||
        !firebaseManager.hasValidIssueId(message)) return;

    final preference = await StreamingSharedPreferences.instance;
    final userRepository = UserRepositoryImplementation(
        preferences: preference); // FirebaseUserRepository
    final user = await userRepository.getUserFromPreference();
    log('_firebaseMessagingBackgroundHandler passed create user repo');
    if (user.isEmptyInstance()) return;

    final String? crashId = message.data[FirebaseManager.KEY_ISSUE_ID];
    log('_firebaseMessagingBackgroundHandler received crash id ==> ${crashId ?? ""}');
    if (crashId == null || crashId.isEmpty) return;
    final issueRepository =
        IssueRepositoryImplementation(preferences: preference);
    issueRepository.saveIssueId(crashId);
    log('_firebaseMessagingBackgroundHandler saved crash id ==> ${crashId ?? ""}');

    CallKitManager().showCallkitIncoming(const Uuid().v4());
  } catch (e) {
    log(e.toString());
  }
}

Future<void> main() async {
  runZonedGuarded(() async {
    WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
    await _initFirebase();
    FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
    Bloc.observer = RoosterBlocObserver();
    runApp(await _roosterApp());
  }, (error, stack) async {
    await FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
  });
}

Future<void> _initFirebase() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  FirebaseAnalyticsObserver observer =
      FirebaseAnalyticsObserver(analytics: analytics);
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
  // Pass all uncaught asynchronous errors that aren't handled by the Flutter framework to Crashlytics
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
}

Future<RoosterApp> _roosterApp() async {
  final StreamingSharedPreferences preferences =
      await StreamingSharedPreferences.instance;
  final UserRepository userRepository =
      UserRepositoryImplementation(preferences: preferences);
  final FcmRepository fcmRepository =
      FcmRepositoryImplementation(preferences: preferences);
  final DeviceInfoRepository deviceInfoRepository =
      DeviceInfoRepositoryImplementation();
  final IssueRepository issueRepository =
      IssueRepositoryImplementation(preferences: preferences);
  return RoosterApp(
      userRepository, fcmRepository, deviceInfoRepository, issueRepository);
}

Future<void> getDevicePushTokenVoIP() async {
  await CallKitManager().getDevicePushTokenVoIP();
}
