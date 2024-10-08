import 'package:rooster/data_stores/entities/firestore_entities/firestore_user_info.dart';
import 'package:rooster/data_stores/entities/user_info.dart';

/// An abstract class that defines the interface for interacting with
/// user data.
///
/// This class outlines a set of methods that any concrete implementation
/// of this repository must provide, ensuring consistency and
/// maintainability when working with user data.

abstract class UserRepository {
  Stream<FirestoreUserInfo> get preferenceUser;

  Stream<FirestoreUserInfo> get firebaseUser;

  Stream<FirestoreUserInfo> fireStoreUserStream(String docId);

  Future<void> saveUserToPreference(FirestoreUserInfo user);

  Future<FirestoreUserInfo> getUserFromPreference();

  Future<FirestoreUserInfo> getFireStoreUser(String email, String platform);

  Future<FirestoreUserInfo> getFireStoreUserBy(String docId);

  Future<void> updateUserDeviceInfoPath(FirestoreUserInfo firestoreUserInfo);

  Future<void> updateUserModifiedAt(FirestoreUserInfo firestoreUserInfo);

  Future<void> addUser(UserInfo user);

  Future<void> deleteUser(FirestoreUserInfo user);

  Future<void> updateUserOnCallState(FirestoreUserInfo firestoreUserInfo);
}
