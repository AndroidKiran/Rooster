import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:rooster/data_stores/entities/firestore_entities/firestore_user_info.dart';
import 'package:rooster/data_stores/repositories/user_repo/user_repository.dart';
import 'package:rooster/screens/models/block_form_item.dart';
import 'package:rooster/utils/string_extensions.dart';

part 'form_verification_event.dart';

part 'form_verification_state.dart';

class FormVerificationBloc
    extends Bloc<FormVerificationEvent, FormVerificationState> {
  final UserRepository _userRepository;

  FormVerificationBloc({required UserRepository userRepository})
      : _userRepository = userRepository,
        super(const FormVerificationState._(
          formStatus: FormStatus.init,
        )) {
    on<UserEmailChangedEvent>(_onEmailChangedState);
    on<PlatformChangedEvent>(_onPlatformChangeState);
    on<FormSubmitEvent>(_onFormSubmitState);
  }

  Future<void> _onEmailChangedState(
      UserEmailChangedEvent event, Emitter<FormVerificationState> emit) async {
    return emit(state.copyWith(
        emailFormItem: BlocFormItem(
            value: event.emailFormItem.value,
            error: event.emailFormItem.value!.isValidEmail
                ? null
                : 'Please enter valid email'),
        formStatus: FormStatus.init));
  }

  Future<void> _onPlatformChangeState(
      PlatformChangedEvent event, Emitter<FormVerificationState> emit) async {
    return emit(state.copyWith(
        platformFormItem: BlocFormItem(
            value: event.platformItem.value,
            error: event.platformItem.value != null
                ? null
                : 'Please choose the platform'),
        formStatus: FormStatus.init));
  }

  Future<void> _onFormSubmitState(
      FormSubmitEvent event, Emitter<FormVerificationState> emit) async {
    var newState = state.copyWith(formStatus: FormStatus.formSubmitting);
    try {
      emit(newState);
      final String? email = state.emailFormItem.value;
      final String? platform = state.platformFormItem.value;
      if (email == null || !email.isValidEmail || platform == null) {
        newState = state.copyWith(formStatus: FormStatus.submitFailure);
        return emit(newState);
      }

      FirestoreUserInfo firestoreUserInfo =
          await _userRepository.getFireStoreUser(email, platform);
      if (firestoreUserInfo.isEmptyInstance()) {
        newState = state.copyWith(formStatus: FormStatus.submitFailure);
      } else {
        await _userRepository.saveUserToPreference(firestoreUserInfo);
        newState = state.copyWith(formStatus: FormStatus.submitSuccess);
      }
    } catch (e) {
      log(e.toString());
      newState = state.copyWith(formStatus: FormStatus.submitFailure);
    }
    return emit(newState);
  }
}
