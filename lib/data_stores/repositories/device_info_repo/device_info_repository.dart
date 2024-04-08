import 'package:rooster/data_stores/entities/device_info.dart';

abstract class DeviceInfoRepository {
  Future<void> updateFirebaseDeviceInfo(DeviceInfo deviceInfo, String docRef);
}
