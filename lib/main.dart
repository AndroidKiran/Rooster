import 'package:bloc/bloc.dart';
import 'package:firebase_core/firebase_core.dart';
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
import 'package:uuid/uuid.dart';
import 'firebase_options.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  if (!FirebaseService.isVelocityAlertNotification(message)) return;

  final preference = await StreamingSharedPreferences.instance;
  final userRepository = UserRepositoryImplementation(
      preferences: preference); // FirebaseUserRepository
  final user = await userRepository.getUserFromPreference();
  if (user.isEmptyInstance()) return;

  final String? crashId = message.data['crash_id'];
  if (crashId == null || crashId.isEmpty) return;
  final crashVelocityRepository =
      CrashVelocityRepositoryImplementation(preferences: preference);
  crashVelocityRepository.saveCrashId(crashId);

  CallKitService.showCallkitIncoming(const Uuid().v4());
}

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
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
  Bloc.observer = RoosterBlocObserver();
  runApp(RoosterApp(userRepository, fcmRepository, deviceInfoRepository,
      crashVelocityRepository));
}
