part of 'add_employee_verification_bloc.dart';

enum FormStatus {
  init,
  formSubmitting,
  submitSuccess,
  submitFailure;
}

@immutable
final class AddEmployeeVerificationState extends Equatable {
  final BlocFormItem emailFormItem;
  final BlocFormItem nameFormItem;
  final BlocFormItem platformFormItem;
  final FormStatus formStatus;

  const AddEmployeeVerificationState._(
      {this.nameFormItem =
          const BlocFormItem(error: 'Please enter valid name', value: null),
      this.emailFormItem =
          const BlocFormItem(error: 'Please enter valid email', value: null),
      this.platformFormItem =
          const BlocFormItem(error: 'Please choose the platform', value: null),
      this.formStatus = FormStatus.init});

  AddEmployeeVerificationState copyWith(
      {BlocFormItem? nameFormItem,
      BlocFormItem? emailFormItem,
      BlocFormItem? platformFormItem,
      FormStatus? formStatus}) {
    return AddEmployeeVerificationState._(
        nameFormItem: nameFormItem ?? this.nameFormItem,
        emailFormItem: emailFormItem ?? this.emailFormItem,
        platformFormItem: platformFormItem ?? this.platformFormItem,
        formStatus: formStatus ?? this.formStatus);
  }

  bool isFromValidationSuccess() {
    bool isValidEmail =
        (emailFormItem.error == null || emailFormItem.error!.isEmpty);
    bool isValidName =
        (nameFormItem.error == null || nameFormItem.error!.isEmpty);
    bool isValidPlatform =
        (platformFormItem.error == null || platformFormItem.error!.isEmpty);
    return isValidEmail && isValidName && isValidPlatform;
  }

  @override
  List<Object?> get props =>
      [emailFormItem, nameFormItem, platformFormItem, formStatus];
}
