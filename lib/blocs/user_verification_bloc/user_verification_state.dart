part of 'user_verification_bloc.dart';

/// Defines the possible states of user verification.
enum VerificationStatus {
  init,
  hasValidUser,
  hasInvalidUser;
}

/// Represents the state of the user verification process.
///
/// This immutable class encapsulates the current verification status
/// and user information, providing a structured way to track the
/// verification process within a BLoC.

@immutable
final class UserVerificationState extends Equatable {
  final VerificationStatus status;
  final FirestoreUserInfo firestoreUserInfo;

  const UserVerificationState._(
      {this.status = VerificationStatus.init,
      this.firestoreUserInfo = FirestoreUserInfo.emptyInstance});

  const UserVerificationState.init() : this._();

  const UserVerificationState.hasValidFirebaseUser(
      FirestoreUserInfo firestoreUserInfo)
      : this._(
            status: VerificationStatus.hasValidUser,
            firestoreUserInfo: firestoreUserInfo);

  const UserVerificationState.hasInvalidUser()
      : this._(
            status: VerificationStatus.hasInvalidUser,
            firestoreUserInfo: FirestoreUserInfo.emptyInstance);

  @override
  List<Object?> get props => [status, firestoreUserInfo];
}
