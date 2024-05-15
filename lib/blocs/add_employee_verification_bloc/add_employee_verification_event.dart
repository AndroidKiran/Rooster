part of 'add_employee_verification_bloc.dart';

@immutable
sealed class AddEmployeeVerificationEvent extends Equatable {}

final class EmailChangedEvent extends AddEmployeeVerificationEvent {
  final BlocFormItem emailFormItem;

  EmailChangedEvent({required this.emailFormItem});

  @override
  List<Object?> get props => [emailFormItem];
}

final class NameChangedEvent extends AddEmployeeVerificationEvent {
  final BlocFormItem nameFormItem;

  NameChangedEvent({required this.nameFormItem});

  @override
  List<Object?> get props => [nameFormItem];
}

final class PlatformChangedEvent extends AddEmployeeVerificationEvent {
  final BlocFormItem platformItem;

  PlatformChangedEvent({required this.platformItem});

  @override
  List<Object?> get props => [platformItem];
}

final class FormSubmitEvent extends AddEmployeeVerificationEvent {
  @override
  List<Object?> get props => [];
}
