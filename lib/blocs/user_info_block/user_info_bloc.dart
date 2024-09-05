import 'dart:async';
import 'dart:developer';

import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:rooster/data_stores/entities/firestore_entities/firestore_user_info.dart';
import 'package:rooster/data_stores/repositories/user_repo/user_repository.dart';

part 'user_info_event.dart';

part 'user_info_state.dart';

/// A BLoC (Business Logic Component) that manages the state of user
/// information in a Flutter application.
///
/// This BLoC listens for changes in user information from Firestore,
/// handles user updates and deletions, and emits corresponding states
/// to update the UI accordingly.

class UserInfoBloc extends Bloc<UserInfoEvent, UserInfoState> {
  final UserRepository _userRepository;
  late final StreamSubscription<FirestoreUserInfo> _firebaseUserSubscription;

  UserInfoBloc({required UserRepository userRepository})
      : _userRepository = userRepository,
        super(const UserInfoState.init()) {
    on<UserInfoStreamEvent>((event, emit) {
      _firebaseUserSubscription =
          _userRepository.fireStoreUserStream(event.userId).listen((value) {
        add(UserInfoStreamUpdateEvent(firestoreUserInfo: value));
      });
    });

    on<UserInfoStreamUpdateEvent>(_onUserInfoStreamUpdatedEvent);
    on<UserInfoUpdatedEvent>(_onUserInfoUpdateEvent);
    on<UserInfoDeleteEvent>(_onUserInfoDeleteEvent);
  }

  Future<void> _onUserInfoStreamUpdatedEvent(
      UserInfoStreamUpdateEvent event, Emitter<UserInfoState> emit) async {
    try {
      emit(const UserInfoState.loading());
      emit(UserInfoState.success(event.firestoreUserInfo));
    } catch (e) {
      log(e.toString());
      emit(const UserInfoState.failure());
    }
  }

  Future<void> _onUserInfoUpdateEvent(
      UserInfoUpdatedEvent event, Emitter<UserInfoState> emit) async {
    try {
      await _userRepository.updateUserOnCallState(event.firestoreUserInfo);
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> _onUserInfoDeleteEvent(
      UserInfoDeleteEvent event, Emitter<UserInfoState> emit) async {
    try {
      await _userRepository.deleteUser(event.firestoreUserInfo);
    } catch (e) {
      log(e.toString());
    }
    emit(const UserInfoState.delete());
  }

  @override
  Future<void> close() {
    _firebaseUserSubscription.cancel();
    return super.close();
  }
}
