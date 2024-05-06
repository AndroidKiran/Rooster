import 'package:equatable/equatable.dart';
import 'package:rooster/data_stores/entities/firestore_entities/firestore_user_info.dart';
import 'package:meta/meta.dart';

@immutable
sealed class UserVerificationEvent extends Equatable {}

@immutable
final class VerifyUserExistsEvent extends UserVerificationEvent {
  final FirestoreUserInfo firestoreUserInfo;

  VerifyUserExistsEvent({required this.firestoreUserInfo});

  @override
  List<Object?> get props => [firestoreUserInfo];
}
