import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import '../../data_stores/entities/user_entity.dart';
import '../../data_stores/repositories/user_repository.dart';

part 'form_verification_event.dart';
part 'form_verification_state.dart';

class FormVerificationBloc extends Bloc<FormVerificationEvent, FormVerificationState> {
  final UserRepository _userRepository;

  FormVerificationBloc({
    required UserRepository userRepository
  }) : _userRepository = userRepository,
        super(const FormVerificationState.init()) {

    on<UserEmailChangedEvent>((event, emit) async {
      emit(state.copyWith(
          formStatus: FormStatus.init,
          user: state.user.copyWith(email: event.email)
      ));
    });

    on<UserEmailSubmittedEvent>((event, emit) async {
      try {
        emit(state.copyWith(formStatus: FormStatus.formSubmitting));
        final user = await _userRepository.getCurrentUserFromFireStore(event.user.email);
        if(user == null || user.isEmptyInstance()) {
          emit(state.copyWith(formStatus: FormStatus.submitFailure));
        } else {
          await _userRepository.saveUserToPreference(user);
          emit(state.copyWith(formStatus: FormStatus.submitSuccess, user: user));
        }
      } catch (e) {
        log(e.toString());
        emit(state.copyWith(formStatus: FormStatus.submitFailure));
      }
    });
  }
}
