part of 'firebase_messaging_bloc.dart';

/// A sealed class representing events that can trigger state changes
/// in the Firebase Cloud Messaging (FCM) BLoC.
@immutable
sealed class FirebaseMessagingEvent extends Equatable {}

/// Event signaling that an FCM message has been received while the
/// app is in the foreground.
final class ForegroundFcmEvent extends FirebaseMessagingEvent {
  final RemoteMessage message;

  ForegroundFcmEvent({required this.message});

  @override
  List<Object?> get props => [message];
}

/// Event signaling a request to refresh the FCM token.
final class RefreshFcmTokenEvent extends FirebaseMessagingEvent {
  final String refreshToken;

  RefreshFcmTokenEvent({required this.refreshToken});

  @override
  List<Object?> get props => [refreshToken];
}
