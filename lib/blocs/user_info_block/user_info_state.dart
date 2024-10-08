part of 'user_info_bloc.dart';

/// Defines the possible states of user information operations.
enum Status {
  init,
  loading,
  fetchSuccess,
  fetchFailure,
  deleteSuccess,
  deleteFailure;
}

/// Represents the state of user information within the BLoC.
///
/// This immutable class encapsulates the current status of user
/// information operations and the user information itself, providing
/// a structured way to track user data within a BLoC.
@immutable
final class UserInfoState extends Equatable {
  final Status status;
  final FirestoreUserInfo firestoreUserInfo;

  const UserInfoState._(
      {this.status = Status.init,
      this.firestoreUserInfo = FirestoreUserInfo.emptyInstance});

  const UserInfoState.init() : this._();

  const UserInfoState.loading()
      : this._(
            status: Status.loading,
            firestoreUserInfo: FirestoreUserInfo.emptyInstance);

  const UserInfoState.success(FirestoreUserInfo firestoreUserInfo)
      : this._(
            status: Status.fetchSuccess, firestoreUserInfo: firestoreUserInfo);

  const UserInfoState.failure()
      : this._(
            status: Status.fetchFailure,
            firestoreUserInfo: FirestoreUserInfo.emptyInstance);

  const UserInfoState.delete()
      : this._(
            status: Status.deleteSuccess,
            firestoreUserInfo: FirestoreUserInfo.emptyInstance);

  @override
  List<Object?> get props => [status, firestoreUserInfo];
}
