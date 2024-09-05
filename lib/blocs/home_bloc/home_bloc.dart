import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:rooster/data_stores/entities/device_info.dart';
import 'package:rooster/data_stores/entities/firestore_entities/firestore_device_info.dart';
import 'package:rooster/data_stores/entities/firestore_entities/firestore_user_info.dart';
import 'package:rooster/data_stores/entities/user_info.dart';
import 'package:rooster/data_stores/repositories/device_info_repo/device_info_repository.dart';
import 'package:rooster/data_stores/repositories/fcm_repo/fcm_repository.dart';
import 'package:rooster/data_stores/repositories/user_repo/user_repository.dart';

part 'home_event.dart';

part 'home_state.dart';

/// A BLoC (Business Logic Component) that manages the state of the
/// home screen in a Flutter application.
///
/// This BLoC handles events related to on-call user updates and
/// token updates, emitting corresponding states to update the UI.
class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final UserRepository _userRepository;
  final DeviceInfoRepository _deviceInfoRepository;
  final FcmRepository _fcmRepository;

  late final StreamSubscription<FirestoreUserInfo> _firebaseUserSubscription;

  HomeBloc(
      {required UserRepository userRepository,
      required DeviceInfoRepository deviceInfoRepository,
      required FcmRepository fcmRepository})
      : _userRepository = userRepository,
        _deviceInfoRepository = deviceInfoRepository,
        _fcmRepository = fcmRepository,
        super(const HomeState.init()) {
    _firebaseUserSubscription = _userRepository.firebaseUser.listen((value) {
      add(OnCallEvent(onCallUser: value));
    });

    on<OnCallEvent>((event, emit) {
      return emit(HomeState.onCallUpdate(event.onCallUser));
    });

    on<UpdateTokenEvent>(_updateTokenState);
  }

  Future<void> _updateTokenState(
      UpdateTokenEvent event, Emitter<HomeState> emit) async {
    FirestoreUserInfo firestoreUserInfo =
        await _userRepository.getUserFromPreference();
    if (firestoreUserInfo == FirestoreUserInfo.emptyInstance) {
      return emit(HomeState.onTokenUpdate(state.firestoreUserInfo));
    }

    firestoreUserInfo =
        await _userRepository.getFireStoreUserBy(firestoreUserInfo.id);
    final UserInfo userInfo = firestoreUserInfo.userEntity;
    final String token = await _fcmRepository.getFcmToken() ?? '';
    final FirestoreDeviceInfo firestoreDeviceInfo =
        await _deviceInfoRepository.getFirebaseDeviceInfo(userInfo);
    final DeviceInfo deviceInfo = firestoreDeviceInfo.deviceInfo;
    if (deviceInfo.fcmToken.isEmpty || token != deviceInfo.fcmToken) {
      final DeviceInfo newDeviceInfo = DeviceInfo.newTokenDeviceInfo(token);
      final FirestoreDeviceInfo newFirestoreDeviceInfo = FirestoreDeviceInfo(
          id: userInfo.getDeviceInfoDocId(), deviceInfo: newDeviceInfo);
      final String docInfoRef =
          await _deviceInfoRepository.updateFirebaseDeviceInfo(
        newFirestoreDeviceInfo,
      );
      final UserInfo newUserInfo = userInfo.copyWith(deviceInfoRef: docInfoRef);
      final FirestoreUserInfo newFirestoreUserInfo =
          FirestoreUserInfo(id: firestoreUserInfo.id, userEntity: newUserInfo);
      await _userRepository.updateUserDeviceInfoPath(newFirestoreUserInfo);
    }
    return emit(HomeState.onTokenUpdate(firestoreUserInfo));
  }

  @override
  Future<void> close() {
    _firebaseUserSubscription.cancel();
    return super.close();
  }
}
