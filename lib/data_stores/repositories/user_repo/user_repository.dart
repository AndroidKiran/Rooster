import 'package:rooster/data_stores/entities/user_entity.dart';

abstract class UserRepository {
  Stream<UserEntity> get user;

  Future<void> saveUserToPreference(UserEntity user);

  Future<UserEntity> getUserFromPreference();

  Future<UserEntity?> getFireStoreUser(String email, String platform);

  Future<void> setUserData(UserEntity user);
}
