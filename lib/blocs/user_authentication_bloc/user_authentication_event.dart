part of 'user_authentication_bloc.dart';

@immutable
sealed class UserAuthenticationEvent extends Equatable {}

final class EmployeeVerificationInitEvent extends UserAuthenticationEvent {
  @override
  List<Object?> get props => [];
}

final class UserEmailChangedEvent extends UserAuthenticationEvent {
  final BlocFormItem emailFormItem;

  UserEmailChangedEvent({required this.emailFormItem});

  @override
  List<Object?> get props => [emailFormItem];
}

final class PlatformChangedEvent extends EmployeeVerificationInitEvent {
  final BlocFormItem platformItem;

  PlatformChangedEvent({required this.platformItem});

  @override
  List<Object?> get props => [platformItem];
}

final class FormSubmitEvent extends EmployeeVerificationInitEvent {
  @override
  List<Object?> get props => [];
}
