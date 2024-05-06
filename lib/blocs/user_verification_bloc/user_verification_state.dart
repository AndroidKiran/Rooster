import 'package:equatable/equatable.dart';
import 'package:rooster/data_stores/entities/user_entity.dart';
import 'package:meta/meta.dart';

enum VerificationStatus {
  init,
  success,
  failure;
}

@immutable
final class UserVerificationState extends Equatable {
  final VerificationStatus status;
  final UserEntity user;

  const UserVerificationState._(
      {this.status = VerificationStatus.init,
      this.user = UserEntity.emptyInstance});

  const UserVerificationState.init() : this._();

  const UserVerificationState.success(UserEntity user)
      : this._(status: VerificationStatus.success, user: user);

  const UserVerificationState.failure()
      : this._(
            status: VerificationStatus.failure, user: UserEntity.emptyInstance);

  UserVerificationState copyWith(
      {VerificationStatus? status, UserEntity? user}) {
    return UserVerificationState._(
        status: status ?? this.status, user: user ?? this.user);
  }

  static UserVerificationState fromFireBaseValue(UserEntity? user) {
    if (user == null || user.isEmptyInstance()) {
      return const UserVerificationState.failure();
    } else {
      return UserVerificationState.success(user);
    }
  }

  @override
  List<Object?> get props => [status, user];
}
