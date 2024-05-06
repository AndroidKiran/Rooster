part of 'home_bloc.dart';

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
