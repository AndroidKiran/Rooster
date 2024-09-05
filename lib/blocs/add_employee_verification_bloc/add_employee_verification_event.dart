part of 'add_employee_verification_bloc.dart';

/// A sealed class representing events that can trigger state changes
/// in the employee verification form BLoC.
@immutable
sealed class AddEmployeeVerificationEvent extends Equatable {}

/// Event signaling a change in the email input field.
final class EmailChangedEvent extends AddEmployeeVerificationEvent {
  final BlocFormItem emailFormItem;

  EmailChangedEvent({required this.emailFormItem});

  @override
  List<Object?> get props => [emailFormItem];
}

/// Event signaling a change in the name input field.
final class NameChangedEvent extends AddEmployeeVerificationEvent {
  final BlocFormItem nameFormItem;

  NameChangedEvent({required this.nameFormItem});

  @override
  List<Object?> get props => [nameFormItem];
}

/// Event signaling a change in the platform selection field.
final class PlatformChangedEvent extends AddEmployeeVerificationEvent {
  final BlocFormItem platformItem;

  PlatformChangedEvent({required this.platformItem});

  @override
  List<Object?> get props => [platformItem];
}

/// Event signaling that the form has been submitted.
final class FormSubmitEvent extends AddEmployeeVerificationEvent {
  @override
  List<Object?> get props => [];
}
