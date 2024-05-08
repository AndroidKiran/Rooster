import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:rooster/data_stores/entities/firestore_entities/firestore_user_info.dart';
import 'package:rooster/data_stores/repositories/user_repo/user_repository.dart';
import 'package:meta/meta.dart';

part 'user_verification_event.dart';

part 'user_verification_state.dart';

class UserVerificationBloc
    extends Bloc<UserVerificationEvent, UserVerificationState> {
  final UserRepository _userRepository;

  late final StreamSubscription<FirestoreUserInfo>
      _preferenceUserIdSubscription;

  UserVerificationBloc({required UserRepository userRepository})
      : _userRepository = userRepository,
        super(const UserVerificationState.init()) {
    _preferenceUserIdSubscription =
        _userRepository.preferenceUser.listen((value) {
      add(PreferenceUserUpdateEvent(firestoreUserInfo: value));
    });

    on<PreferenceUserUpdateEvent>(_onPreferenceUserUpdatedEvent);
  }

  Future<void> _onPreferenceUserUpdatedEvent(PreferenceUserUpdateEvent event,
      Emitter<UserVerificationState> emit) async {
    UserVerificationState newState =
        const UserVerificationState.hasInvalidUser();
    final FirestoreUserInfo firestoreUserInfo = event.firestoreUserInfo;
    if (firestoreUserInfo != FirestoreUserInfo.emptyInstance) {
      newState = UserVerificationState.hasValidFirebaseUser(firestoreUserInfo);
    }
    return emit(newState);
  }

  @override
  Future<void> close() {
    _preferenceUserIdSubscription.cancel();
    return super.close();
  }
}
