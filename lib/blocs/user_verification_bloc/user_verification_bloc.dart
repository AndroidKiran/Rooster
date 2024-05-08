import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:rooster/data_stores/entities/device_info.dart';
import 'package:rooster/data_stores/entities/firestore_entities/firestore_device_info.dart';
import 'package:rooster/data_stores/entities/firestore_entities/firestore_user_info.dart';
import 'package:rooster/data_stores/entities/user_info.dart';
import 'package:rooster/data_stores/repositories/device_info_repo/device_info_repository.dart';
import 'package:rooster/data_stores/repositories/fcm_repo/fcm_repository.dart';
import 'package:rooster/data_stores/repositories/user_repo/user_repository.dart';
import 'package:meta/meta.dart';

part 'user_verification_event.dart';

part 'user_verification_state.dart';

class UserVerificationBloc
    extends Bloc<UserVerificationEvent, UserVerificationState> {
  final UserRepository _userRepository;
  final FcmRepository _fcmRepository;
  final DeviceInfoRepository _deviceInfoRepository;

  late final StreamSubscription<FirestoreUserInfo>
      _preferenceUserIdSubscription;

  UserVerificationBloc({
    required UserRepository userRepository,
    required FcmRepository fcmRepository,
    required DeviceInfoRepository deviceInfoRepository,
  })  : _userRepository = userRepository,
        _fcmRepository = fcmRepository,
        _deviceInfoRepository = deviceInfoRepository,
        super(const UserVerificationState.init()) {
    _preferenceUserIdSubscription =
        _userRepository.preferenceUser.listen((value) {
      add(VerifyUserExistsEvent(firestoreUserInfo: value));
    });

    on<VerifyUserExistsEvent>(_onAppInitEvent);
  }

  Future<void> _onAppInitEvent(
      VerifyUserExistsEvent event, Emitter<UserVerificationState> emit) async {
    UserVerificationState newState = const UserVerificationState.failure();
    final FirestoreUserInfo firestoreUserInfo = event.firestoreUserInfo;
    if (firestoreUserInfo != FirestoreUserInfo.emptyInstance) {
      newState = UserVerificationState.success(firestoreUserInfo);
    }
    return emit(newState);
  }

  Future<UserVerificationState> _executeTransaction(
      String email, String platform) async {
    FirestoreUserInfo firestoreUserInfo =
        await _userRepository.getFireStoreUser(email, platform);
    if (firestoreUserInfo == FirestoreUserInfo.emptyInstance) {
      return const UserVerificationState.failure();
    }
    final UserInfo userInfo = firestoreUserInfo.userEntity;
    final String token = await _fcmRepository.getFcmToken() ?? '';
    final FirestoreDeviceInfo firestoreDeviceInfo =
        await _deviceInfoRepository.getFirebaseDeviceInfo(userInfo);
    final DeviceInfo deviceInfo = firestoreDeviceInfo.deviceInfo;
    if (deviceInfo.fcmToken.isEmpty || token != deviceInfo.fcmToken) {
      final DeviceInfo newDeviceInfo = DeviceInfo.newTokenDeviceInfo(token);
      final FirestoreDeviceInfo newFirestoreDeviceInfo = FirestoreDeviceInfo(
          id: userInfo.getDeviceInfoDocId(), deviceInfo: newDeviceInfo);
      final String docInfoRef = await _deviceInfoRepository
          .updateFirebaseDeviceInfo(newFirestoreDeviceInfo);
      final UserInfo newUserInfo = userInfo.copyWith(deviceInfoRef: docInfoRef);
      firestoreUserInfo =
          FirestoreUserInfo(id: firestoreUserInfo.id, userEntity: newUserInfo);
      await _userRepository.updateUserDeviceInfoPath(firestoreUserInfo);
    }
    return UserVerificationState.success(firestoreUserInfo);
  }

  @override
  Future<void> close() {
    _preferenceUserIdSubscription.cancel();
    return super.close();
  }
}
