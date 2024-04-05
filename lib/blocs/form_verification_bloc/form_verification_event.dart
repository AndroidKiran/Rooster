part of 'form_verification_bloc.dart';

@immutable
sealed class FormVerificationEvent extends Equatable {}
class UserEmailChangedEvent extends FormVerificationEvent {
  final String email;

  UserEmailChangedEvent({required this.email});

  @override
  List<Object?> get props => [email];
}

class UserEmailSubmittedEvent extends FormVerificationEvent {
  UserEmailSubmittedEvent({required this.user});
  final UserEntity user;

  @override
  List<Object?> get props => [user];
}
