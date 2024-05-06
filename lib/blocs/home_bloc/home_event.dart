part of 'home_bloc.dart';

@immutable
sealed class HomeEvent extends Equatable {}

final class OnCallEvent extends HomeEvent {
  final FirestoreUserInfo onCallUser;

  OnCallEvent({required this.onCallUser});

  @override
  List<Object?> get props => [onCallUser];
}

final class UpdateTokenEvent extends HomeEvent {
  @override
  List<Object?> get props => [];
}
