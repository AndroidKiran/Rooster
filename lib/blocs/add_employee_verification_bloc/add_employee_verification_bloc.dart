import 'dart:developer';

import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:rooster/data_stores/entities/user_info.dart';
import 'package:rooster/data_stores/repositories/user_repo/user_repository.dart';
import 'package:rooster/screens/models/block_form_item.dart';
import 'package:rooster/utils/string_extensions.dart';

part 'add_employee_verification_event.dart';

part 'add_employee_verification_state.dart';

/// A BLoC (Business Logic Component) that manages the state and events
/// related to adding and verifying employee information through a form.
///
/// This BLoC handles events like changes in form fields and form
/// submission, emitting corresponding states to update the UI.

class AddEmployeeVerificationBloc
    extends Bloc<AddEmployeeVerificationEvent, AddEmployeeVerificationState> {
  final UserRepository _userRepository;

  AddEmployeeVerificationBloc({required UserRepository userRepository})
      : _userRepository = userRepository,
        super(const AddEmployeeVerificationState._()) {
    on<NameChangedEvent>(_onNameChangeState);
    on<EmailChangedEvent>(_onEmailChangedState);
    on<PlatformChangedEvent>(_onPlatformChangeState);
    on<FormSubmitEvent>(_onFormSubmitState);
  }

  Future<void> _onNameChangeState(NameChangedEvent event,
      Emitter<AddEmployeeVerificationState> emit) async {
    return emit(state.copyWith(
        nameFormItem: BlocFormItem(
            value: event.nameFormItem.value,
            error: (event.nameFormItem.value != null &&
                    event.nameFormItem.value!.isNotEmpty)
                ? null
                : 'Please enter valid name'),
        formStatus: FormStatus.init));
  }

  Future<void> _onEmailChangedState(EmailChangedEvent event,
      Emitter<AddEmployeeVerificationState> emit) async {
    return emit(state.copyWith(
        emailFormItem: BlocFormItem(
            value: event.emailFormItem.value,
            error: event.emailFormItem.value!.isValidEmail
                ? null
                : 'Please enter valid email'),
        formStatus: FormStatus.init));
  }

  Future<void> _onPlatformChangeState(PlatformChangedEvent event,
      Emitter<AddEmployeeVerificationState> emit) async {
    return emit(state.copyWith(
        platformFormItem: BlocFormItem(
            value: event.platformItem.value,
            error: (event.platformItem.value != null &&
                    event.platformItem.value!.isNotEmpty)
                ? null
                : 'Please choose the platform'),
        formStatus: FormStatus.init));
  }

  Future<void> _onFormSubmitState(
      FormSubmitEvent event, Emitter<AddEmployeeVerificationState> emit) async {
    var newState = state.copyWith(formStatus: FormStatus.formSubmitting);
    try {
      emit(newState);
      final String? name = state.nameFormItem.value;
      final String? email = state.emailFormItem.value;
      final String? platform = state.platformFormItem.value;
      if (name == null ||
          name.isEmpty ||
          email == null ||
          !email.isValidEmail ||
          platform == null ||
          platform.isEmpty) {
        newState = state.copyWith(formStatus: FormStatus.submitFailure);
        return emit(newState);
      }
      final currentTime = Timestamp.now().millisecondsSinceEpoch;
      final UserInfo userInfo = UserInfo(
          name: name,
          email: email,
          platform: platform,
          deviceInfoRef: "",
          isOnCall: false,
          isAdmin: false,
          createdAt: currentTime,
          modifiedAt: currentTime);

      await _userRepository.addUser(userInfo);
      newState = state.copyWith(formStatus: FormStatus.submitSuccess);
    } catch (e) {
      log(e.toString());
      newState = state.copyWith(formStatus: FormStatus.submitFailure);
    }
    return emit(newState);
  }
}
