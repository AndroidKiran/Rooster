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
    try {
      if (event.user == UserEntity.emptyInstance) {
        return emit(const UserVerificationState.failure());
      } else {
        final isRefreshTokenSyncCompleted =
            await _fcmRepository.isRefreshTokenSyncCompleted();
        if (!isRefreshTokenSyncCompleted) {
          final token = await _fcmRepository.getFcmToken();
          if (token != null) {
            final deviceInfo = DeviceInfo.newTokenDeviceInfo(token);
            _deviceInfoRepository.updateFirebaseDeviceInfo(
              deviceInfo,
              event.user.deviceInfoRef,
            );
            await _fcmRepository.setRefreshTokenSyncState(true);
          }
        }
        return emit(UserVerificationState.success(event.user));
      }
    } catch (e) {
      log(e.toString());
      return emit(const UserVerificationState.failure());
    }
  }

  @override
  Future<void> close() {
    _preferenceUserIdSubscription.cancel();
    return super.close();
  }
}
