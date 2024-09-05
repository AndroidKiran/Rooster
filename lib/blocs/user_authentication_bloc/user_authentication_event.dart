part of 'user_authentication_bloc.dart';

/// A sealed class representing events that can trigger state changes
/// in the user authentication BLoC.
@immutable
sealed class UserAuthenticationEvent extends Equatable {}

/// Event signaling the initialization of the employee verification process.
final class EmployeeVerificationInitEvent extends UserAuthenticationEvent {
  @override
  List<Object?> get props => [];
}

/// Event signaling a change in the email input field.
final class UserEmailChangedEvent extends UserAuthenticationEvent {
  final BlocFormItem emailFormItem;

  UserEmailChangedEvent({required this.emailFormItem});

  @override
  List<Object?> get props => [emailFormItem];
}

/// Event signaling a change in the platform selection field.
final class PlatformChangedEvent extends EmployeeVerificationInitEvent {
  final BlocFormItem platformItem;

  PlatformChangedEvent({required this.platformItem});

  @override
  List<Object?> get props => [platformItem];
}

/// Event signaling the submission of the authentication form.
final class FormSubmitEvent extends EmployeeVerificationInitEvent {
  @override
  List<Object?> get props => [];
}
