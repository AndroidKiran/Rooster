import 'dart:async';
import 'dart:developer';
import 'package:bloc/bloc.dart';
import 'package:rooster/blocs/user_verification_bloc/user_verification_event.dart';
import 'package:rooster/blocs/user_verification_bloc/user_verification_state.dart';
import 'package:rooster/data_stores/entities/device_info.dart';
import 'package:rooster/data_stores/entities/user_entity.dart';
import 'package:rooster/data_stores/repositories/device_info_repo/device_info_repository.dart';
import 'package:rooster/data_stores/repositories/fcm_repo/fcm_repository.dart';
import 'package:rooster/data_stores/repositories/user_repo/user_repository.dart';

class UserVerificationBloc
    extends Bloc<UserVerificationEvent, UserVerificationState> {
  final UserRepository _userRepository;
  final FcmRepository _fcmRepository;
  final DeviceInfoRepository _deviceInfoRepository;

  late final StreamSubscription<UserEntity> _preferenceUserIdSubscription;

  UserVerificationBloc({
    required UserRepository userRepository,
    required FcmRepository fcmRepository,
    required DeviceInfoRepository deviceInfoRepository,
  })  : _userRepository = userRepository,
        _fcmRepository = fcmRepository,
        _deviceInfoRepository = deviceInfoRepository,
        super(const UserVerificationState.init()) {
    _preferenceUserIdSubscription = _userRepository.user.listen((value) {
      add(VerifyUserExistsEvent(user: value));
    });

    on<VerifyUserExistsEvent>(_onAppInitEvent);
  }

  Future<void> _onAppInitEvent(
      VerifyUserExistsEvent event, Emitter<UserVerificationState> emit) async {
    var currentEvent = const UserVerificationState.failure();
    var user = event.user;
    try {
      if (user != UserEntity.emptyInstance) {
        currentEvent = await _executeTransaction(user.email, user.platform);
      }
      return emit(currentEvent);
    } catch (e) {
      log(e.toString());
      return emit(currentEvent);
    }
  }

  Future<UserVerificationState> _executeTransaction(
      String email, String platform) async {
    UserEntity user = await _userRepository.getFireStoreUser(email, platform);
    if (user == UserEntity.emptyInstance) {
      return const UserVerificationState.failure();
    }
    final String token = await _fcmRepository.getFcmToken() ?? '';
    final DeviceInfo deviceInfo =
        await _deviceInfoRepository.getFirebaseDeviceInfo(user.deviceInfoRef);
    if (token.isEmpty ||
        deviceInfo.fcmToken.isEmpty ||
        token != deviceInfo.fcmToken) {
      final deviceInfo = DeviceInfo.newTokenDeviceInfo(token);
      final String docInfoRef =
          await _deviceInfoRepository.updateFirebaseDeviceInfo(
        deviceInfo,
        user.deviceInfoRef,
      );
      await _userRepository.updateUserDeviceInfoPath(user, docInfoRef);
      user = await _userRepository.getUserFromPreference();
    }
    return UserVerificationState.success(user);
  }

  @override
  Future<void> close() {
    _preferenceUserIdSubscription.cancel();
    return super.close();
  }
}
