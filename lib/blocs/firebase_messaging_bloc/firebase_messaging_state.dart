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

final class VelocityCrashFcmMessageState extends FirebaseMessagingState {
  final RemoteMessage message;

  VelocityCrashFcmMessageState({required this.message});

  @override
  List<Object?> get props => [message];
}

final class RefreshFcmTokenState extends FirebaseMessagingState {
  @override
  List<Object?> get props => [];
}
