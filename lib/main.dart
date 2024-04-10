import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:rooster/data_stores/repositories/crash_velocity_repo/crash_velocity_repository.dart';
import 'package:rooster/data_stores/repositories/crash_velocity_repo/crash_velocity_repository_impl.dart';
import 'package:rooster/data_stores/repositories/device_info_repo/device_info_repository.dart';
import 'package:rooster/data_stores/repositories/device_info_repo/device_info_repository_impl.dart';
import 'package:rooster/data_stores/repositories/fcm_repo/fcm_repository.dart';
import 'package:rooster/data_stores/repositories/fcm_repo/fcm_repository_impl.dart';
import 'package:rooster/data_stores/repositories/user_repo/user_repository.dart';
import 'package:rooster/data_stores/repositories/user_repo/user_repository_impl.dart';
import 'package:rooster/rooster_bloc_observer.dart';
import 'package:rooster/rooster_app.dart';
import 'package:rooster/services/call_kit_service.dart';
import 'package:rooster/services/firebase_service.dart';
import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:uuid/uuid.dart';
import 'firebase_options.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    if (!FirebaseService.isVelocityAlertNotification(message)) return;
    final preference = await StreamingSharedPreferences.instance;
    final String? crashId = message.data['crash_id'];
    log('_firebaseMessagingBackgroundHandler passed crash id');
    if (crashId == null || crashId.isEmpty) return;
    final crashVelocityRepository =
        CrashVelocityRepositoryImplementation(preferences: preference);
    crashVelocityRepository.saveCrashId(crashId);
    log('_firebaseMessagingBackgroundHandler passed save crash id');
    final userRepository = UserRepositoryImplementation(
        preferences: preference); // FirebaseUserRepository
    final user = await userRepository.getUserFromPreference();
    log('_firebaseMessagingBackgroundHandler passed create user repo');
    if (user.isEmptyInstance()) return;
    log('_firebaseMessagingBackgroundHandler passed create user verification');
    CallKitService.showCallkitIncoming(const Uuid().v4());
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
  final CrashVelocityRepository crashVelocityRepository =
      CrashVelocityRepositoryImplementation(preferences: preferences);
  return RoosterApp(userRepository, fcmRepository, deviceInfoRepository,
      crashVelocityRepository);
}
