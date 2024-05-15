part of 'user_authentication_bloc.dart';

enum FormStatus {
  init,
  formSubmitting,
  submitSuccess,
  submitFailure;
}

@immutable
final class UserAuthenticationState extends Equatable {
  final BlocFormItem emailFormItem;
  final BlocFormItem platformFormItem;
  final FormStatus formStatus;

  const UserAuthenticationState._(
      {this.emailFormItem =
          const BlocFormItem(error: 'Please enter valid email', value: null),
      this.platformFormItem =
          const BlocFormItem(error: 'Please choose the platform', value: null),
      this.formStatus = FormStatus.init});

  UserAuthenticationState copyWith(
      {BlocFormItem? emailFormItem,
      BlocFormItem? platformFormItem,
      FormStatus? formStatus}) {
    return UserAuthenticationState._(
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
