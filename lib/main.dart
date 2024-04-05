import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:rooster/rooster_bloc_observer.dart';
import 'package:rooster/rooster_app.dart';
import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';
import 'data_stores/repositories/implmentations/firebase_user_repository.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  Bloc.observer = RoosterBlocObserver();
  runApp(RoosterApp(FirebaseUserRepository(
      preferences: await StreamingSharedPreferences.instance
  )));
}
