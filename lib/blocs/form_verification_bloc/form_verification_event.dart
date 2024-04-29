part of 'form_verification_bloc.dart';

@immutable
sealed class FormVerificationEvent extends Equatable {}

final class FormInitEvent extends FormVerificationEvent {
  @override
  List<Object?> get props => [];
}

@immutable
final class UserEmailChangedEvent extends FormVerificationEvent {
  final BlocFormItem emailFormItem;

  UserEmailChangedEvent({required this.emailFormItem});

  @override
  List<Object?> get props => [emailFormItem];
}

@immutable
final class PlatformChangedEvent extends FormVerificationEvent {
  final BlocFormItem platformItem;

  PlatformChangedEvent({required this.platformItem});

  @override
  List<Object?> get props => [platformItem];
}

@immutable
final class FormSubmitEvent extends FormVerificationEvent {
  @override
  List<Object?> get props => [];
}
