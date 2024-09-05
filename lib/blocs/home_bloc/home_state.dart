part of 'home_bloc.dart';

/// Represents the state of the home screen within the BLoC.
///
/// This immutable class encapsulates the current state of the home
/// screen, particularly focusing on user information and updates
/// related to on-call status and tokens.
@immutable
final class HomeState extends Equatable {
  final FirestoreUserInfo firestoreUserInfo;

  const HomeState._({this.firestoreUserInfo = FirestoreUserInfo.emptyInstance});

  const HomeState.init() : this._();

  const HomeState.onCallUpdate(FirestoreUserInfo firestoreUserInfo)
      : this._(firestoreUserInfo: firestoreUserInfo);

  const HomeState.onTokenUpdate(FirestoreUserInfo firestoreUserInfo)
      : this._(firestoreUserInfo: firestoreUserInfo);

  @override
  List<Object?> get props => [firestoreUserInfo];
}
