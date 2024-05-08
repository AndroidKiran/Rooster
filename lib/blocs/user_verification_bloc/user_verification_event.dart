part of 'user_verification_bloc.dart';

@immutable
sealed class UserVerificationEvent extends Equatable {}

final class VerifyUserExistsEvent extends UserVerificationEvent {
  final FirestoreUserInfo firestoreUserInfo;

  VerifyUserExistsEvent({required this.firestoreUserInfo});

  @override
  List<Object?> get props => [firestoreUserInfo];
}
