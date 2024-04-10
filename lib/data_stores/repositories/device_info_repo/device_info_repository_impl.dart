import 'dart:developer';

import 'package:rooster/data_stores/entities/device_info.dart';
import 'package:rooster/data_stores/repositories/device_info_repo/device_info_repository.dart';
import 'package:rooster/services/firebase_service.dart';

class DeviceInfoRepositoryImplementation extends DeviceInfoRepository {
  final _deviceInfoCollection =
      FirebaseService.roosterFireStore().collection(DEVICE_INFO_COLLECTION);

  @override
  Future<void> updateFirebaseDeviceInfo(
      DeviceInfo deviceInfo, String docRef) async {
    try {
      final List<String> pathList = docRef.split("/");
      if (pathList.isEmpty || pathList.length < 2) {
        throw const FormatException('Invalid reference format');
      }

      final String docId = pathList[1];
      final informationSnapShot = await _deviceInfoCollection.doc(docId).get();

      if (informationSnapShot.exists) {
        return await _deviceInfoCollection
            .doc(docId)
            .update({"fcmToken": deviceInfo.fcmToken, "os": deviceInfo.os});
      } else {
        return await _deviceInfoCollection.doc(docId).set(deviceInfo.toJson());
      }
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  static const String DEVICE_INFO_COLLECTION = "deviceInfo";
}
