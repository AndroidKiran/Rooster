import 'dart:convert';
import 'dart:developer';
import 'package:rooster/data_stores/repositories/user_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';
import '../../entities/user_entity.dart';

class FirebaseUserRepository implements UserRepository {
  final StreamingSharedPreferences _preferences;
  final userCollection = FirebaseFirestore.instance.collection(USER_COLLECTION);

  FirebaseUserRepository({
    required StreamingSharedPreferences preferences
  }): _preferences = preferences;

  @override
  Stream<UserEntity> get user {
    return _preferences.getString(PREFERENCE_USER, defaultValue: '')
        .map((value) {
          var map = <String, dynamic>{};
          if(value.isNotEmpty) {
            map = jsonDecode(value);
          }
          return UserEntity.fromJson(map);
        });
  }
  
  @override
  Future<void> saveUserToPreference(UserEntity user) async {
    try {
      await _preferences.setString(PREFERENCE_USER, jsonEncode(user.toJson()));
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  @override
  Future<UserEntity> getCurrentUserFromFireStore(String email) async {
    try {
      final snapshot = await userCollection.doc(email).get();
      if(!snapshot.exists) { return UserEntity.emptyInstance;}
      final data = snapshot.data() ?? <String, dynamic>{};
      return UserEntity.fromJson(data);
    } catch (e) {
      log(e.toString());
      return UserEntity.emptyInstance;
    }
  }

  @override
  Future<void> setUserData(UserEntity user) async {
    try {
      await userCollection
          .doc(user.email)
          .set(user.toJson());
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  static const String USER_COLLECTION = "users";
  static const String PREFERENCE_USER = "user";
}