import 'package:rooster/data_stores/entities/device_info.dart';

abstract class DeviceInfoRepository {
  Future<String> updateFirebaseDeviceInfo(DeviceInfo deviceInfo, String docRef);

  Future<DeviceInfo> getFirebaseDeviceInfo(String docRef);

  Future<String> getFirebaseDocId(String docRef);
}
