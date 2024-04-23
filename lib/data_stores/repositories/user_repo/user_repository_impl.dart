import 'dart:convert';
import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rooster/data_stores/entities/user_entity.dart';
import 'package:rooster/data_stores/repositories/user_repo/user_repository.dart';
import 'package:rooster/services/firebase_service.dart';
import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';

class UserRepositoryImplementation implements UserRepository {
  final StreamingSharedPreferences _preferences;
  final _userCollection =
      FirebaseService().firestore.collection(USER_COLLECTION);

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
        return UserEntity.fromJson(map);
      }
    });
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
      final users = await _userCollection
          .where("email", isEqualTo: email)
          .where("platform", isEqualTo: platform)
          .get();
      final QueryDocumentSnapshot<Map<String, dynamic>>? documentSnapshot =
          users.docs.firstOrNull;
      if (documentSnapshot != null && documentSnapshot.exists) {
        currentUser = UserEntity.fromJson(documentSnapshot.data());
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
      final users = await _userCollection
          .where("email", isEqualTo: user.email)
          .where("platform", isEqualTo: user.platform)
          .get();
      final QueryDocumentSnapshot<Map<String, dynamic>>? documentSnapshot =
          users.docs.firstOrNull;
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

  static const String USER_COLLECTION = "users";
  static const String PREFERENCE_USER = "user";
}
