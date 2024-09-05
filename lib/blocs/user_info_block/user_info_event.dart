part of 'user_info_bloc.dart';

/// A sealed class representing events that can trigger state changes
/// in the user information BLoC.
@immutable
sealed class UserInfoEvent extends Equatable {}

/// Event initiating a stream to fetch user information.
final class UserInfoStreamEvent extends UserInfoEvent {
  final String userId;

  UserInfoStreamEvent({required this.userId});

  @override
  List<Object?> get props => [userId];
}

/// Event signaling an update to user information from the stream.
final class UserInfoStreamUpdateEvent extends UserInfoEvent {
  final FirestoreUserInfo firestoreUserInfo;

  UserInfoStreamUpdateEvent({required this.firestoreUserInfo});

  @override
  List<Object?> get props => [firestoreUserInfo];
}

/// Event indicating successful update of user information.
final class UserInfoUpdatedEvent extends UserInfoEvent {
  final FirestoreUserInfo firestoreUserInfo;

  UserInfoUpdatedEvent({required this.firestoreUserInfo});

  @override
  List<Object?> get props => [firestoreUserInfo];
}

/// Event signaling a request to delete user information.
final class UserInfoDeleteEvent extends UserInfoEvent {
  final FirestoreUserInfo firestoreUserInfo;

  UserInfoDeleteEvent({required this.firestoreUserInfo});

  @override
  List<Object?> get props => [firestoreUserInfo];
}
