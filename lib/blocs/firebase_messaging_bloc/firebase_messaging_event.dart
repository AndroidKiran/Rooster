part of 'firebase_messaging_bloc.dart';

@immutable
sealed class FirebaseMessagingEvent extends Equatable {}

@immutable
final class ForegroundFcmEvent extends FirebaseMessagingEvent {
  final RemoteMessage message;

  ForegroundFcmEvent({required this.message});

  @override
  List<Object?> get props => [message];
}

@immutable
final class RefreshFcmTokenEvent extends FirebaseMessagingEvent {
  final String refreshToken;

  RefreshFcmTokenEvent({required this.refreshToken});

  @override
  List<Object?> get props => [refreshToken];
}
