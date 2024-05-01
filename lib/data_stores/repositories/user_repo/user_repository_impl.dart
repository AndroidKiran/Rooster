import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rooster/data_stores/entities/user_entity.dart';
import 'package:rooster/data_stores/repositories/user_repo/user_repository.dart';
import 'package:rooster/services/firebase_service.dart';
import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';

class UserRepositoryImplementation implements UserRepository {
  final StreamingSharedPreferences _preferences;
  final _userCollection = FirebaseService().userDb;

  UserRepositoryImplementation(
      {required StreamingSharedPreferences preferences})
      : _preferences = preferences;

  @override
  Stream<UserEntity> get user {
    return _preferences
        .getString(PREFERENCE_USER, defaultValue: '')
        .map((value) {
      var map = <String, dynamic>{};
      if (value.isNotEmpty) {
        map = jsonDecode(value);
      }
      if (map.isEmpty) {
        return UserEntity.emptyInstance;
      } else {
        return UserEntity.fromPreferenceJson(map);
      }
    });
  }

  @override
  Stream<UserEntity> get firebaseUser async* {
    UserEntity userEntity = await getUserFromPreference();
    if (userEntity.isEmptyInstance()) {
      yield userEntity;
    } else {
      yield* _userCollection
          .where('email', isEqualTo: userEntity.email)
          .where('platform', isEqualTo: userEntity.platform)
          .orderBy('platform')
          .limit(1)
          .snapshots()
          .map((documentSnapshots) {
        if (documentSnapshots.size > 0) {
          return documentSnapshots.docs[0].data();
        } else {
          return userEntity;
        }
      });
    }
  }

  @override
  Future<void> saveUserToPreference(UserEntity user) async {
    try {
      await _preferences.setString(
          PREFERENCE_USER, jsonEncode(user.toPreferenceJson()));
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  @override
  Future<UserEntity> getUserFromPreference() async {
    var currentUser = UserEntity.emptyInstance;
    try {
      final userJson =
          _preferences.getString(PREFERENCE_USER, defaultValue: '').getValue();
      if (userJson.isNotEmpty) {
        currentUser = UserEntity.fromPreferenceJson(jsonDecode(userJson));
      }
      return currentUser;
    } catch (e) {
      log(e.toString());
      return currentUser;
    }
  }

  @override
  Future<UserEntity> getFireStoreUser(String email, String platform) async {
    var currentUser = UserEntity.emptyInstance;
    try {
      final QuerySnapshot<UserEntity> querySnapshot =
          await getCurrentFirebaseUser(email, platform);
      if (querySnapshot.size > 0) {
        currentUser = querySnapshot.docs[0].data();
      }
      return currentUser;
    } catch (e) {
      log(e.toString());
      return currentUser;
    }
  }

  @override
  Future<void> updateUserDeviceInfoPath(
      UserEntity user, String deviceInfoPath) async {
    try {
      final QuerySnapshot<UserEntity> querySnapshot =
          await getCurrentFirebaseUser(user.email, user.platform);
      final QueryDocumentSnapshot<UserEntity>? documentSnapshot =
          querySnapshot.docs.firstOrNull;
      if (documentSnapshot != null && documentSnapshot.exists) {
        await _userCollection
            .doc(documentSnapshot.id)
            .update({"deviceInfoRef": deviceInfoPath});
        await saveUserToPreference(
            user.copyWith(deviceInfoRef: deviceInfoPath));
      }
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  Future<QuerySnapshot<UserEntity>> getCurrentFirebaseUser(
      String email, String platform) async {
    return await _userCollection
        .where('email', isEqualTo: email)
        .where('platform', isEqualTo: platform)
        .orderBy('platform')
        .limit(1)
        .get();
  }

  static const String PREFERENCE_USER = "user";
}
