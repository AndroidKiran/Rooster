import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:rooster/data_stores/entities/device_info.dart';
import 'package:rooster/data_stores/repositories/crash_velocity_repo/crash_velocity_repository.dart';
import 'package:rooster/data_stores/repositories/device_info_repo/device_info_repository.dart';
import 'package:rooster/data_stores/repositories/fcm_repo/fcm_repository.dart';
import 'package:rooster/data_stores/repositories/user_repo/user_repository.dart';
import 'package:rooster/services/firebase_service.dart';

part 'firebase_messaging_event.dart';

part 'firebase_messaging_state.dart';

class FirebaseMessagingBloc
    extends Bloc<FirebaseMessagingEvent, FirebaseMessagingState> {
  final FcmRepository _fcmRepository;
  final DeviceInfoRepository _deviceInfoRepository;
  final UserRepository _userRepository;
  final CrashVelocityRepository _crashVelocityRepository;

  late final StreamSubscription<RemoteMessage> _messageForegroundSubscription;
  late final StreamSubscription<RemoteMessage> _messageBackgroundSubscription;
  late final StreamSubscription<String> _refreshTokenSubscription;

  FirebaseMessagingBloc(
      {required FcmRepository fcmRepository,
      required DeviceInfoRepository deviceInfoRepository,
      required UserRepository userRepository,
      required CrashVelocityRepository crashVelocityRepository})
      : _fcmRepository = fcmRepository,
        _deviceInfoRepository = deviceInfoRepository,
        _userRepository = userRepository,
        _crashVelocityRepository = crashVelocityRepository,
        super(FirebaseMessagingInitState()) {
    _messageForegroundSubscription =
        _fcmRepository.messageForegroundState.listen((message) {
      add(ForegroundFcmEvent(message: message));
    });

    _messageBackgroundSubscription =
        _fcmRepository.messageBackgroundState.listen((message) {
      add(ForegroundFcmEvent(message: message));
    });

    _refreshTokenSubscription =
        _fcmRepository.refreshToken.listen((refreshToken) {
      add(RefreshFcmTokenEvent(refreshToken: refreshToken));
    });

    on<ForegroundFcmEvent>(_onNotificationReceivedEvent);
    on<RefreshFcmTokenEvent>(_onTokenRefreshEvent);
  }

  Future<void> _onNotificationReceivedEvent(
      ForegroundFcmEvent event, Emitter<FirebaseMessagingState> emit) async {
    try {
      final message = event.message;
      log('Message title: ${message.notification?.title}, body: ${message.notification?.body}, data: ${message.data}');
      if (!FirebaseService.isVelocityAlertNotification(message)) return;
      final user = await _userRepository.getUserFromPreference();
      if (user.isEmptyInstance()) return;
      final String? crashId = message.data['crash_id'];
      if (crashId == null || crashId.isEmpty) return;
      _crashVelocityRepository.saveCrashId(crashId);
      return emit(VelocityCrashFcmMessageState(message: event.message));
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> _onTokenRefreshEvent(
      RefreshFcmTokenEvent event, Emitter<FirebaseMessagingState> emit) async {
    try {
      await _fcmRepository.setRefreshTokenSyncState(false);
      final user = await _userRepository.getUserFromPreference();
      if (user.isEmptyInstance()) return;
      final deviceInfo = DeviceInfo.newTokenDeviceInfo(event.refreshToken);
      await _deviceInfoRepository.updateFirebaseDeviceInfo(
          deviceInfo, user.deviceInfoRef);
      await _fcmRepository.setRefreshTokenSyncState(true);
      return emit(RefreshFcmTokenState());
    } catch (e) {
      log(e.toString());
      return;
    }
  }

  @override
  Future<void> close() {
    _messageForegroundSubscription.cancel();
    _messageBackgroundSubscription.cancel();
    _refreshTokenSubscription.cancel();
    return super.close();
  }

  static const String CRASH_VELOCITY_NOTIFICATION_TYPE =
      "crash_velocity_notification_type";
}
