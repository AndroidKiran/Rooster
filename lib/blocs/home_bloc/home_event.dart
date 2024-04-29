part of 'home_bloc.dart';

@immutable
sealed class HomeEvent extends Equatable {}

@immutable
final class OnCallEvent extends HomeEvent {
  final UserEntity onCallUser;

  OnCallEvent({required this.onCallUser});

  @override
  List<Object?> get props => [onCallUser];
}
