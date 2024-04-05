import 'dart:async';
import 'dart:developer';
import 'package:bloc/bloc.dart';
import 'package:rooster/blocs/user_verification_bloc/user_verification_event.dart';
import 'package:rooster/blocs/user_verification_bloc/user_verification_state.dart';
import 'package:rooster/data_stores/entities/user_entity.dart';
import '../../data_stores/repositories/user_repository.dart';

class UserVerificationBloc extends Bloc<UserVerificationEvent, UserVerificationState> {
  final UserRepository _userRepository;
  late final StreamSubscription<UserEntity> _preferenceUserIdSubscription;

  UserVerificationBloc({
    required UserRepository userRepository,
  }) : _userRepository = userRepository,
        super(const UserVerificationState.init()) {
    _preferenceUserIdSubscription = _userRepository.user.listen((value) {
      add(VerifyUserExistsEvent(user: value));
    });

    on<VerifyUserExistsEvent>((event, emit) async {
      try {
        if (event.user != UserEntity.emptyInstance) {
          emit(UserVerificationState.success(event.user));
        } else {
          emit(const UserVerificationState.failure());
        }
      } catch (e) {
        log(e.toString());
        emit(const UserVerificationState.failure());
      }
    });
  }

  @override
  Future<void> close() {
    _preferenceUserIdSubscription.cancel();
    return super.close();
  }
}
