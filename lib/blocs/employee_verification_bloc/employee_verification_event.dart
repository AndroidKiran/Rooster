part of 'employee_verification_bloc.dart';

@immutable
sealed class EmployeeVerificationEvent extends Equatable {}

final class EmployeeVerificationInitEvent extends EmployeeVerificationEvent {
  @override
  List<Object?> get props => [];
}

final class UserEmailChangedEvent extends EmployeeVerificationEvent {
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
