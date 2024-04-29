import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:rooster/data_stores/entities/user_entity.dart';
import 'package:rooster/data_stores/repositories/user_repo/user_repository.dart';

part 'home_event.dart';

part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final UserRepository _userRepository;
  late final StreamSubscription<UserEntity> _firebaseUserSubscription;

  HomeBloc({
    required UserRepository userRepository,
  })  : _userRepository = userRepository,
        super(HomeInitState()) {
    _firebaseUserSubscription = _userRepository.firebaseUser.listen((value) {
      add(OnCallEvent(onCallUser: value));
    });

    on<OnCallEvent>((event, emit) {
      return emit(OnCallState(onCallUser: event.onCallUser));
    });
  }

  @override
  Future<void> close() {
    _firebaseUserSubscription.cancel();
    return super.close();
  }
}
