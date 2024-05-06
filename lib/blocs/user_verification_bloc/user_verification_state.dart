import 'package:equatable/equatable.dart';
import 'package:rooster/data_stores/entities/firestore_entities/firestore_user_info.dart';
import 'package:meta/meta.dart';

enum VerificationStatus {
  init,
  success,
  failure;
}

@immutable
final class UserVerificationState extends Equatable {
  final VerificationStatus status;
  final FirestoreUserInfo firestoreUserInfo;

  const UserVerificationState._(
      {this.status = VerificationStatus.init,
      this.firestoreUserInfo = FirestoreUserInfo.emptyInstance});

  const UserVerificationState.init() : this._();

  const UserVerificationState.success(FirestoreUserInfo firestoreUserInfo)
      : this._(
            status: VerificationStatus.success,
            firestoreUserInfo: firestoreUserInfo);

  const UserVerificationState.failure()
      : this._(
            status: VerificationStatus.failure,
            firestoreUserInfo: FirestoreUserInfo.emptyInstance);

  @override
  List<Object?> get props => [status, firestoreUserInfo];
}
