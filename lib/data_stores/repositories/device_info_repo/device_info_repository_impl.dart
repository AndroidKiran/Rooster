import 'dart:developer';

import 'package:rooster/data_stores/entities/firestore_entities/firestore_device_info.dart';
import 'package:rooster/data_stores/entities/user_info.dart';
import 'package:rooster/data_stores/repositories/device_info_repo/device_info_repository.dart';
import 'package:rooster/helpers/firebase_manager.dart';

class DeviceInfoRepositoryImplementation extends DeviceInfoRepository {
  final _deviceInfoDb = FirebaseManager().deviceInfoDb;

  @override
  Future<String> updateFirebaseDeviceInfo(
      FirestoreDeviceInfo firestoreDeviceInfo) async {
    var path = '';
    try {
      final String docId = firestoreDeviceInfo.id;
      if (docId.isEmpty) {
        final result = await _deviceInfoDb.add(firestoreDeviceInfo);
        path = '${FirebaseManager.DEVICE_INFO_COLLECTION}/${result.id}';
      } else {
        final deviceInfo = firestoreDeviceInfo.deviceInfo;
        await _deviceInfoDb
            .doc(docId)
            .update({"fcmToken": deviceInfo.fcmToken, "os": deviceInfo.os});
        path = '${FirebaseManager.DEVICE_INFO_COLLECTION}/$docId';
      }
    } catch (e) {
      log(e.toString());
    }
    return path;
  }

  @override
  Future<FirestoreDeviceInfo> getFirebaseDeviceInfo(UserInfo userInfo) async {
    var currentDeviceInfo = FirestoreDeviceInfo.emptyInstance;
    try {
      final docId = userInfo.getDeviceInfoDocId();
      final informationSnapShot = await _deviceInfoDb.doc(docId).get();
      if (informationSnapShot.exists) {
        currentDeviceInfo =
            informationSnapShot.data() ?? FirestoreDeviceInfo.emptyInstance;
      }
      return currentDeviceInfo;
    } catch (e) {
      log(e.toString());
      return currentDeviceInfo;
    }
  }
}
