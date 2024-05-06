import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:rooster/data_stores/entities/device_info.dart';
import 'package:rooster/data_stores/entities/firestore_entities/firestore_device_info.dart';
import 'package:rooster/data_stores/repositories/device_info_repo/device_info_repository.dart';
import 'package:rooster/data_stores/repositories/fcm_repo/fcm_repository.dart';
import 'package:rooster/utils/string_extensions.dart';
import '../../data_stores/entities/user_entity.dart';
import '../../data_stores/repositories/user_repo/user_repository.dart';
import '../../screens/models/block_form_item.dart';

part 'form_verification_event.dart';

part 'form_verification_state.dart';

class FormVerificationBloc
    extends Bloc<FormVerificationEvent, FormVerificationState> {
  final UserRepository _userRepository;
  final DeviceInfoRepository _deviceInfoRepository;
  final FcmRepository _fcmRepository;

  FormVerificationBloc(
      {required UserRepository userRepository,
      required DeviceInfoRepository deviceInfoRepository,
      required FcmRepository fcmRepository})
      : _userRepository = userRepository,
        _deviceInfoRepository = deviceInfoRepository,
        _fcmRepository = fcmRepository,
        super(const FormVerificationState._(
          formStatus: FormStatus.init,
        )) {
    on<UserEmailChangedEvent>(_onEmailChangedState);
    on<PlatformChangedEvent>(_onPlatformChangeState);
    on<FormSubmitEvent>(_onFormSubmitState);
  }

  Future<void> _onEmailChangedState(
      UserEmailChangedEvent event, Emitter<FormVerificationState> emit) async {
    emit(state.copyWith(
      emailFormItem: BlocFormItem(
          value: event.emailFormItem.value,
          error: event.emailFormItem.value!.isValidEmail
              ? null
              : 'Please enter valid email'),
    ));
  }

  Future<void> _onPlatformChangeState(
      PlatformChangedEvent event, Emitter<FormVerificationState> emit) async {
    emit(state.copyWith(
      platformFormItem: BlocFormItem(
          value: event.platformItem.value,
          error: event.platformItem.value != null
              ? null
              : 'Please choose the platform'),
    ));
  }

  Future<void> _onFormSubmitState(
      FormSubmitEvent event, Emitter<FormVerificationState> emit) async {
    try {
      emit(state.copyWith(formStatus: FormStatus.formSubmitting));
      final email = state.emailFormItem.value!;
      final platform = state.platformFormItem.value;
      if (!email.isValidEmail || platform == null) {
        return emit(state.copyWith(formStatus: FormStatus.submitFailure));
      }

      var user = await _userRepository.getFireStoreUser(email, platform);
      if (user.isEmptyInstance()) {
        return emit(state.copyWith(formStatus: FormStatus.submitFailure));
      }

      final token = await _fcmRepository.getFcmToken() ?? '';
      final FirestoreDeviceInfo firestoreDeviceInfo =
          await _deviceInfoRepository.getFirebaseDeviceInfo(user);
      final deviceInfo = firestoreDeviceInfo.deviceInfo;
      if (deviceInfo.fcmToken.isEmpty || token != deviceInfo.fcmToken) {
        final newDeviceInfo = DeviceInfo.newTokenDeviceInfo(token);
        final newFirestoreDeviceInfo = FirestoreDeviceInfo(
            id: user.getDeviceInfoDocId(), deviceInfo: newDeviceInfo);
        final String docInfoRef =
            await _deviceInfoRepository.updateFirebaseDeviceInfo(
          newFirestoreDeviceInfo,
        );
        await _userRepository.updateUserDeviceInfoPath(user, docInfoRef);
        user = await _userRepository.getUserFromPreference();
      }
      return emit(
          state.copyWith(formStatus: FormStatus.submitSuccess, user: user));
    } catch (e) {
      log(e.toString());
      return emit(state.copyWith(formStatus: FormStatus.submitFailure));
    }
  }
}
