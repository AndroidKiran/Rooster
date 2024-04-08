part of 'form_verification_bloc.dart';

enum FormStatus {
  init,
  formSubmitting,
  submitSuccess,
  submitFailure;
}

class FormVerificationState extends Equatable {
  final GlobalKey<FormState>? formKey;
  final BlocFormItem emailFormItem;
  final BlocFormItem platformFormItem;
  final FormStatus formStatus;

  const FormVerificationState._(
      {this.formKey,
      this.emailFormItem =
          const BlocFormItem(error: 'Please enter valid email'),
      this.platformFormItem =
          const BlocFormItem(error: 'Please choose the platform'),
      this.formStatus = FormStatus.init});

  FormVerificationState copyWith(
      {GlobalKey<FormState>? formKey,
      BlocFormItem? emailFormItem,
      BlocFormItem? platformFormItem,
      FormStatus? formStatus,
      UserEntity? user}) {
    return FormVerificationState._(
        formKey: formKey ?? this.formKey,
        emailFormItem: emailFormItem ?? this.emailFormItem,
        platformFormItem: platformFormItem ?? this.platformFormItem,
        formStatus: formStatus ?? this.formStatus);
  }

  @override
  List<Object?> get props =>
      [formKey, emailFormItem, platformFormItem, formStatus];
}
