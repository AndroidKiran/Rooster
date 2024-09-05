import 'package:rooster/data_stores/entities/firestore_entities/firestore_device_info.dart';
import 'package:rooster/data_stores/entities/user_info.dart';

/// An abstract class that defines the interface for interacting with
/// device information.
///
/// This class outlines a set of methods that any concrete implementation
/// of this repository must provide, ensuring consistency and
/// maintainability when working with device information.

abstract class DeviceInfoRepository {
  Future<String> updateFirebaseDeviceInfo(
      FirestoreDeviceInfo firestoreDeviceInfo);

  Future<FirestoreDeviceInfo> getFirebaseDeviceInfo(UserInfo userInfo);
}
