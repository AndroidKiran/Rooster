part of 'home_bloc.dart';

@immutable
sealed class HomeState extends Equatable {}

@immutable
final class HomeInitState extends HomeState {
  final UserEntity onCallUser;

  HomeInitState({this.onCallUser = UserEntity.emptyInstance});

  @override
  List<Object?> get props => [onCallUser];
}

@immutable
final class OnCallState extends HomeState {
  final UserEntity onCallUser;

  OnCallState({required this.onCallUser});

  @override
  List<Object?> get props => [onCallUser];
}
