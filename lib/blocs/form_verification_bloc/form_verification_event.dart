part of 'form_verification_bloc.dart';

@immutable
sealed class FormVerificationEvent extends Equatable {}

class FormInitEvent extends FormVerificationEvent {
  @override
  List<Object?> get props => [];
}

class UserEmailChangedEvent extends FormVerificationEvent {
  final BlocFormItem emailFormItem;

  UserEmailChangedEvent({required this.emailFormItem});

  @override
  List<Object?> get props => [emailFormItem];
}

class PlatformChangedEvent extends FormVerificationEvent {
  final BlocFormItem platformItem;

  PlatformChangedEvent({required this.platformItem});

  @override
  List<Object?> get props => [platformItem];
}

class FormSubmitEvent extends FormVerificationEvent {
  @override
  List<Object?> get props => [];
}
