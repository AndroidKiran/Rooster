
import '../entities/user_entity.dart';

abstract class UserRepository {

  Stream<UserEntity> get user;

  Future<void> saveUserToPreference(UserEntity user);

  Future<UserEntity?> getCurrentUserFromFireStore(String email);

  Future<void> setUserData(UserEntity user);

}