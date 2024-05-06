import 'package:rooster/data_stores/entities/firestore_entities/firestore_device_info.dart';
import 'package:rooster/data_stores/entities/user_entity.dart';

abstract class DeviceInfoRepository {
  Future<String> updateFirebaseDeviceInfo(
      FirestoreDeviceInfo firestoreDeviceInfo);

  Future<FirestoreDeviceInfo> getFirebaseDeviceInfo(UserEntity userEntity);
}
