part of 'user_info_bloc.dart';

enum Status {
  init,
  loading,
  fetchSuccess,
  fetchFailure,
  deleteSuccess,
  deleteFailure;
}

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
