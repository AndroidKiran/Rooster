import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rooster/data_stores/entities/firestore_entities/firestore_user_info.dart';
import 'package:rooster/data_stores/entities/user_info.dart';
import 'package:rooster/data_stores/repositories/user_repo/user_repository.dart';
import 'package:rooster/helpers/firebase_manager.dart';
import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';

class UserRepositoryImplementation implements UserRepository {
  final StreamingSharedPreferences _preferences;
  final _userCollection = FirebaseManager().userDb;

  UserRepositoryImplementation(
      {required StreamingSharedPreferences preferences})
      : _preferences = preferences;

  @override
  Stream<FirestoreUserInfo> get preferenceUser {
    return _preferences
        .getString(PREFERENCE_USER, defaultValue: '')
        .map((value) {
      var map = <String, dynamic>{};
      if (value.isNotEmpty) {
        map = jsonDecode(value);
      }
      if (map.isEmpty) {
        return FirestoreUserInfo.emptyInstance;
      } else {
        return FirestoreUserInfo.fromPreferenceJson(map);
      }
    });
  }

  @override
  Stream<FirestoreUserInfo> get firebaseUser async* {
    final FirestoreUserInfo firestoreUserInfo = await getUserFromPreference();
    final UserInfo userInfo = firestoreUserInfo.userEntity;
    yield* _userCollection
        .where('email', isEqualTo: userInfo.email)
        .where('platform', isEqualTo: userInfo.platform)
        .orderBy('platform')
        .limit(1)
        .snapshots()
        .map((documentSnapshots) {
      if (documentSnapshots.size > 0) {
        return documentSnapshots.docs[0].data();
      } else {
        return firestoreUserInfo;
      }
    });
  }

  @override
  Future<void> saveUserToPreference(FirestoreUserInfo firestoreUserInfo) async {
    try {
      await _preferences.setString(
          PREFERENCE_USER, jsonEncode(firestoreUserInfo.toPreferenceJson()));
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  @override
  Future<FirestoreUserInfo> getUserFromPreference() async {
    var currentUser = FirestoreUserInfo.emptyInstance;
    try {
      final userJson =
          _preferences.getString(PREFERENCE_USER, defaultValue: '').getValue();
      if (userJson.isNotEmpty) {
        currentUser =
            FirestoreUserInfo.fromPreferenceJson(jsonDecode(userJson));
      }
    } catch (e) {
      log(e.toString());
    }
    return currentUser;
  }

  @override
  Future<void> updateUserDeviceInfoPath(
      FirestoreUserInfo firestoreUserInfo) async {
    try {
      await _userCollection.doc(firestoreUserInfo.id).update(
          {"deviceInfoRef": firestoreUserInfo.userEntity.deviceInfoRef});
      await saveUserToPreference(firestoreUserInfo);
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  @override
  Future<FirestoreUserInfo> getFireStoreUser(
      String email, String platform) async {
    FirestoreUserInfo firestoreUserInfo = FirestoreUserInfo.emptyInstance;
    final QuerySnapshot<FirestoreUserInfo> querySnapshot = await _userCollection
        .where('email', isEqualTo: email)
        .where('platform', isEqualTo: platform)
        .orderBy('platform')
        .limit(1)
        .get();
    if (querySnapshot.size > 0) {
      firestoreUserInfo = querySnapshot.docs[0].data();
    }
    return firestoreUserInfo;
  }

  @override
  Future<FirestoreUserInfo> getCurrentFireStoreUser(String docId) async {
    FirestoreUserInfo firestoreUserInfo = FirestoreUserInfo.emptyInstance;
    final DocumentSnapshot<FirestoreUserInfo> documentSnapshot =
        await _userCollection.doc(docId).get();
    if (documentSnapshot.exists) {
      firestoreUserInfo =
          documentSnapshot.data() ?? FirestoreUserInfo.emptyInstance;
    }
    return firestoreUserInfo;
  }

  static const String PREFERENCE_USER = "user";
}
