import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:rooster/data_stores/entities/device_info.dart';
import 'package:rooster/data_stores/entities/firestore_entities/firestore_device_info.dart';
import 'package:rooster/data_stores/repositories/device_info_repo/device_info_repository.dart';
import 'package:rooster/data_stores/repositories/fcm_repo/fcm_repository.dart';
import 'package:rooster/data_stores/repositories/issue_repo/issue_repository.dart';
import 'package:rooster/data_stores/repositories/user_repo/user_repository.dart';
import 'package:rooster/helpers/firebase_manager.dart';

part 'firebase_messaging_event.dart';

part 'firebase_messaging_state.dart';

class FirebaseMessagingBloc
    extends Bloc<FirebaseMessagingEvent, FirebaseMessagingState> {
  final FcmRepository _fcmRepository;
  final DeviceInfoRepository _deviceInfoRepository;
  final UserRepository _userRepository;
  final IssueRepository _issueRepository;

  late final StreamSubscription<RemoteMessage> _messageForegroundSubscription;
  late final StreamSubscription<RemoteMessage> _messageBackgroundSubscription;
  late final StreamSubscription<String> _refreshTokenSubscription;

  FirebaseMessagingBloc(
      {required FcmRepository fcmRepository,
      required DeviceInfoRepository deviceInfoRepository,
      required UserRepository userRepository,
      required IssueRepository issueRepository})
      : _fcmRepository = fcmRepository,
        _deviceInfoRepository = deviceInfoRepository,
        _userRepository = userRepository,
        _issueRepository = issueRepository,
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
      FirebaseManager firebaseManager = FirebaseManager();
      if (!firebaseManager.isIssueNotification(message) ||
          !firebaseManager.hasValidIssueId(message)) return;

      final user = await _userRepository.getUserFromPreference();
      if (user.isEmptyInstance()) return;

      final String? issueId = message.data[FirebaseManager.KEY_ISSUE_ID];
      log('__onNotificationReceivedEvent received crash id ==> ${issueId ?? ""}');
      if (issueId == null || issueId.isEmpty) return;

      _issueRepository.saveIssueId(issueId);
      log('_onNotificationReceivedEvent saved crash id ==> $issueId');

      return emit(PerformVoipCallState(message: event.message));
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> _onTokenRefreshEvent(
      RefreshFcmTokenEvent event, Emitter<FirebaseMessagingState> emit) async {
    try {
      final user = await _userRepository.getUserFromPreference();
      if (user.isEmptyInstance()) return;
      final deviceInfo = DeviceInfo.newTokenDeviceInfo(event.refreshToken);
      final firestoreDeviceInfo = FirestoreDeviceInfo(
          id: user.getDeviceInfoDocId(), deviceInfo: deviceInfo);
      final String deviceInfoDocPath = await _deviceInfoRepository
          .updateFirebaseDeviceInfo(firestoreDeviceInfo);
      if (user.deviceInfoRef != deviceInfoDocPath) {
        await _userRepository.updateUserDeviceInfoPath(user, deviceInfoDocPath);
      }
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
