part of 'user_verification_bloc.dart';

/// A sealed class representing events that can trigger state changes
/// in the user verification BLoC.
@immutable
sealed class UserVerificationEvent extends Equatable {}

/// Event signaling an update to user information from shared preferences.
final class PreferenceUserUpdateEvent extends UserVerificationEvent {
  final FirestoreUserInfo firestoreUserInfo;

  PreferenceUserUpdateEvent({required this.firestoreUserInfo});

  @override
  List<Object?> get props => [firestoreUserInfo];
}

/// Event signaling an update to user information from Firebase Authentication.
final class FirebaseUserUpdateEvent extends UserVerificationEvent {
  final FirestoreUserInfo firestoreUserInfo;

  FirebaseUserUpdateEvent({required this.firestoreUserInfo});

  @override
  List<Object?> get props => [firestoreUserInfo];
}
