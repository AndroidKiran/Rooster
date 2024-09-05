part of 'firebase_messaging_bloc.dart';

/// Defines the possible error types that can occur during FCM token refresh.
enum RefreshTokenErrorType {
  invalidUser,
  deviceInfoFailed,
  unknownError;
}

/// A sealed class representing the different states of the FCM BLoC.
@immutable
sealed class FirebaseMessagingState extends Equatable {}

/// Represents the initial state of the FCM BLoC.
final class FirebaseMessagingInitState extends FirebaseMessagingState {
  @override
  List<Object?> get props => [];
}

/// Represents a state where a VoIP call should be performed.
final class PerformVoipCallState extends FirebaseMessagingState {
  final RemoteMessage message;

  PerformVoipCallState({required this.message});

  @override
  List<Object?> get props => [message];
}

/// Represents a state where the FCM token is being refreshed.
final class RefreshFcmTokenState extends FirebaseMessagingState {
  @override
  List<Object?> get props => [];
}
