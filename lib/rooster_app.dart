import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:rooster/blocs/firebase_messaging_bloc/firebase_messaging_bloc.dart';
import 'package:rooster/blocs/form_verification_bloc/form_verification_bloc.dart';
import 'package:rooster/blocs/home_bloc/home_bloc.dart';
import 'package:rooster/blocs/user_verification_bloc/user_verification_state.dart';
import 'package:rooster/blocs/user_verification_bloc/user_verification_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rooster/data_stores/repositories/crash_velocity_repo/crash_velocity_repository.dart';
import 'package:rooster/data_stores/repositories/device_info_repo/device_info_repository.dart';
import 'package:rooster/data_stores/repositories/fcm_repo/fcm_repository.dart';
import 'package:rooster/data_stores/repositories/user_repo/user_repository.dart';
import 'package:rooster/screens/routes/rooster_router.dart';
import 'package:rooster/services/call_kit_service.dart';
import 'package:rooster/services/firebase_service.dart';
import 'package:uuid/uuid.dart';

class RoosterApp extends StatefulWidget {
  final UserRepository userRepository;
  final FcmRepository fcmRepository;
  final DeviceInfoRepository deviceInfoRepository;
  final CrashVelocityRepository crashVelocityRepository;

  const RoosterApp(this.userRepository, this.fcmRepository,
      this.deviceInfoRepository, this.crashVelocityRepository,
      {super.key});

  @override
  State<StatefulWidget> createState() => _RoosterApp();
}

class _RoosterApp extends State<RoosterApp> with WidgetsBindingObserver {
  final router = RoosterRouter().router;
  late final UserRepository _userRepository;
  late final FcmRepository _fcmRepository;
  late final DeviceInfoRepository _deviceInfoRepository;
  late final CrashVelocityRepository _crashVelocityRepository;

  @override
  void initState() {
    super.initState();
    _userRepository = widget.userRepository;
    _fcmRepository = widget.fcmRepository;
    _deviceInfoRepository = widget.deviceInfoRepository;
    _crashVelocityRepository = widget.crashVelocityRepository;

    FirebaseService().setupFirebase();
    // Register your State class as a binding observer
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    // Unregister your State class as a binding observer
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  // Override the didChangeAppLifecycleState method and
  // listen to the app lifecycle state changes
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    switch (state) {
      case AppLifecycleState.detached:
        _onDetached();
      case AppLifecycleState.resumed:
        _onResumed();
      case AppLifecycleState.inactive:
        _onInactive();
      case AppLifecycleState.hidden:
        _onHidden();
      case AppLifecycleState.paused:
        _onPaused();
    }
  }

  void _onDetached() => log('Rooster detached');

  void _onResumed() => log('Rooster resumed');

  void _onInactive() => log('Rooster inactive');

  void _onHidden() => log('Rooster hidden');

  void _onPaused() => log('Rooster paused');

  @override
  Widget build(BuildContext context) {
    FlutterNativeSplash.remove();
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<FirebaseMessagingBloc>(
            create: (context) => FirebaseMessagingBloc(
                fcmRepository: _fcmRepository,
                deviceInfoRepository: _deviceInfoRepository,
                userRepository: _userRepository,
                crashVelocityRepository: _crashVelocityRepository)),
        RepositoryProvider<UserVerificationBloc>(
            create: (context) => UserVerificationBloc(
                userRepository: _userRepository,
                fcmRepository: _fcmRepository,
                deviceInfoRepository: _deviceInfoRepository)),
        RepositoryProvider<FormVerificationBloc>(
          create: (context) => FormVerificationBloc(
              userRepository: _userRepository,
              deviceInfoRepository: _deviceInfoRepository,
              fcmRepository: _fcmRepository),
        ),
        RepositoryProvider<HomeBloc>(
          create: (context) => HomeBloc(userRepository: _userRepository),
        ),
      ],
      child: MultiBlocListener(
        listeners: [
          BlocListener<FirebaseMessagingBloc, FirebaseMessagingState>(
            listener: (context, state) {
              switch (state) {
                case VelocityCrashFcmMessageState():
                  CallKitService().showCallkitIncoming(const Uuid().v4());
                  break;

                case RefreshFcmTokenState():
                  log("Fcm token refresh completed");
                  break;

                default:
                  break;
              }
            },
          ),
          BlocListener<UserVerificationBloc, UserVerificationState>(
            listener: (context, state) {
              router.refresh();
            },
          ),
        ],
        child: MaterialApp.router(
          debugShowCheckedModeBanner: true,
          routeInformationParser: router.routeInformationParser,
          routeInformationProvider: router.routeInformationProvider,
          routerDelegate: router.routerDelegate,
          backButtonDispatcher: RootBackButtonDispatcher(),
        ),
      ),
    );
  }
}
