import 'package:rooster/data_stores/entities/firestore_entities/firestore_user_info.dart';

abstract class UserRepository {
  Stream<FirestoreUserInfo> get preferenceUser;

  Stream<FirestoreUserInfo> get firebaseUser;

  Future<void> saveUserToPreference(FirestoreUserInfo user);

  Future<FirestoreUserInfo> getUserFromPreference();

  Future<FirestoreUserInfo> getFireStoreUser(String email, String platform);

  Future<FirestoreUserInfo> getCurrentFireStoreUser(String docId);

  Future<void> updateUserDeviceInfoPath(FirestoreUserInfo firestoreUserInfo);

  Future<void> updateUserModifiedAt(FirestoreUserInfo firestoreUserInfo);
}
