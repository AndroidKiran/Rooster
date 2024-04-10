import 'dart:convert';
import 'dart:developer';
import 'package:rooster/data_stores/entities/user_entity.dart';
import 'package:rooster/data_stores/repositories/user_repo/user_repository.dart';
import 'package:rooster/services/firebase_service.dart';
import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';

class UserRepositoryImplementation implements UserRepository {
  final StreamingSharedPreferences _preferences;
  final _userCollection =
      FirebaseService.roosterFireStore().collection(USER_COLLECTION);

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
    try {
      final userJson = _preferences
          .getString(PREFERENCE_USER, defaultValue: '')
          .getValue();
      var map = <String, dynamic>{};
      if (userJson.isNotEmpty) {
        map = jsonDecode(userJson);
      }
      return UserEntity.fromPreferenceJson(map);
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  @override
  Future<UserEntity> getFireStoreUser(String email, String platform) async {
    try {
      final users = await _userCollection
          .where("email", isEqualTo: email)
          .where("platform", isEqualTo: platform)
          .get();
      if (users.docs.isEmpty) {
        return UserEntity.emptyInstance;
      }
      final data = users.docs.first.data();
      return UserEntity.fromJson(data);
    } catch (e) {
      log(e.toString());
      return UserEntity.emptyInstance;
    }
  }

  @override
  Future<void> setUserData(UserEntity user) async {
    try {
      await _userCollection.doc(user.email).set(user.toJson());
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  static const String USER_COLLECTION = "users";
  static const String PREFERENCE_USER = "user";
}
