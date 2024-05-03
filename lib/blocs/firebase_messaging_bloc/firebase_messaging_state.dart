part of 'firebase_messaging_bloc.dart';

enum RefreshTokenErrorType {
  invalidUser,
  deviceInfoFailed,
  unknownError;
}

@immutable
sealed class FirebaseMessagingState extends Equatable {}

final class FirebaseMessagingInitState extends FirebaseMessagingState {
  @override
  List<Object?> get props => [];
}

@immutable
final class PerformVoipCallState extends FirebaseMessagingState {
  final RemoteMessage message;

  PerformVoipCallState({required this.message});

  @override
  List<Object?> get props => [message];
}

@immutable
final class RefreshFcmTokenState extends FirebaseMessagingState {
  @override
  List<Object?> get props => [];
}
