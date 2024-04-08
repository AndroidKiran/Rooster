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
      final informationSnapShot = await _deviceInfoCollection.doc(docRef).get();

      if (informationSnapShot.exists) {
        _deviceInfoCollection
            .doc(docRef)
            .update({"fcmToken": deviceInfo.fcmToken, "os": deviceInfo.os});
      } else {
        _deviceInfoCollection.doc(docRef).set(deviceInfo.toJson());
      }
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  static const String DEVICE_INFO_COLLECTION = "device_information_collection";
}
