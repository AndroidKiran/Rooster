part of 'home_bloc.dart';

/// A sealed class representing events that can trigger state changes
/// in the home screen BLoC.
@immutable
sealed class HomeEvent extends Equatable {}

/// Event signaling a change in the on-call user.
final class OnCallEvent extends HomeEvent {
  final FirestoreUserInfo onCallUser;

  OnCallEvent({required this.onCallUser});

  @override
  List<Object?> get props => [onCallUser];
}

/// Event signaling a request to update the user's token.
final class UpdateTokenEvent extends HomeEvent {
  @override
  List<Object?> get props => [];
}
