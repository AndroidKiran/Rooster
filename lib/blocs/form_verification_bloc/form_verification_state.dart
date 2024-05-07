part of 'form_verification_bloc.dart';

enum FormStatus {
  init,
  formSubmitting,
  submitSuccess,
  submitFailure;
}

@immutable
final class FormVerificationState extends Equatable {
  final BlocFormItem emailFormItem;
  final BlocFormItem platformFormItem;
  final FormStatus formStatus;

  const FormVerificationState._(
      {this.emailFormItem =
          const BlocFormItem(error: 'Please enter valid email', value: null),
      this.platformFormItem =
          const BlocFormItem(error: 'Please choose the platform', value: null),
      this.formStatus = FormStatus.init});

  FormVerificationState copyWith(
      {BlocFormItem? emailFormItem,
      BlocFormItem? platformFormItem,
      FormStatus? formStatus}) {
    return FormVerificationState._(
        emailFormItem: emailFormItem ?? this.emailFormItem,
        platformFormItem: platformFormItem ?? this.platformFormItem,
        formStatus: formStatus ?? this.formStatus);
  }

  bool isFromValidationSuccess() {
    bool isValidEmail =
        (emailFormItem.error == null || emailFormItem.error!.isEmpty);
    bool isValidPlatform =
        (platformFormItem.error == null || platformFormItem.error!.isEmpty);
    return isValidEmail && isValidPlatform;
  }

  @override
  List<Object?> get props => [emailFormItem, platformFormItem, formStatus];
}
