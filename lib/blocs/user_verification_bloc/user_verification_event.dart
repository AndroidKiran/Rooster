part of 'user_verification_bloc.dart';

@immutable
sealed class UserVerificationEvent extends Equatable {}

final class PreferenceUserUpdateEvent extends UserVerificationEvent {
  final FirestoreUserInfo firestoreUserInfo;

  PreferenceUserUpdateEvent({required this.firestoreUserInfo});

  @override
  List<Object?> get props => [firestoreUserInfo];
}

final class FirebaseUserUpdateEvent extends UserVerificationEvent {
  final FirestoreUserInfo firestoreUserInfo;

  FirebaseUserUpdateEvent({required this.firestoreUserInfo});

  @override
  List<Object?> get props => [firestoreUserInfo];
}
