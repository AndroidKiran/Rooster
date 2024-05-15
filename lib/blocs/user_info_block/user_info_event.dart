part of 'user_info_bloc.dart';

@immutable
sealed class UserInfoEvent extends Equatable {}

final class UserInfoStreamEvent extends UserInfoEvent {
  final String userId;

  UserInfoStreamEvent({required this.userId});

  @override
  List<Object?> get props => [userId];
}

final class UserInfoStreamUpdateEvent extends UserInfoEvent {
  final FirestoreUserInfo firestoreUserInfo;

  UserInfoStreamUpdateEvent({required this.firestoreUserInfo});

  @override
  List<Object?> get props => [firestoreUserInfo];
}

final class UserInfoUpdatedEvent extends UserInfoEvent {
  final FirestoreUserInfo firestoreUserInfo;

  UserInfoUpdatedEvent({required this.firestoreUserInfo});

  @override
  List<Object?> get props => [firestoreUserInfo];
}

final class UserInfoDeleteEvent extends UserInfoEvent {
  final FirestoreUserInfo firestoreUserInfo;

  UserInfoDeleteEvent({required this.firestoreUserInfo});

  @override
  List<Object?> get props => [firestoreUserInfo];
}
