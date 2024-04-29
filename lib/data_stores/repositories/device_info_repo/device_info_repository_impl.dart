import 'dart:developer';

import 'package:rooster/data_stores/entities/device_info.dart';
import 'package:rooster/data_stores/repositories/device_info_repo/device_info_repository.dart';
import 'package:rooster/services/firebase_service.dart';

class DeviceInfoRepositoryImplementation extends DeviceInfoRepository {
  final _deviceInfoCollection = FirebaseService()
      .fireStore
      .collection(DEVICE_INFO_COLLECTION)
      .withConverter(
          fromFirestore: (snapshot, _) => DeviceInfo.fromJson(snapshot.data()!),
          toFirestore: (deviceInfo, _) => deviceInfo.toJson());

  @override
  Future<String> updateFirebaseDeviceInfo(
      DeviceInfo deviceInfo, String docRef) async {
    try {
      var path = '';
      final String docId = await getFirebaseDocId(docRef);
      if (docId.isEmpty) {
        final result = await _deviceInfoCollection.add(deviceInfo);
        path = "$DEVICE_INFO_COLLECTION/${result.id}";
      } else {
        await _deviceInfoCollection
            .doc(docId)
            .update({"fcmToken": deviceInfo.fcmToken, "os": deviceInfo.os});
        path = "$DEVICE_INFO_COLLECTION/$docId";
      }
      return path;
    } catch (e) {
      log(e.toString());
      return '';
    }
  }

  @override
  Future<DeviceInfo> getFirebaseDeviceInfo(String docRef) async {
    var currentDeviceInfo = DeviceInfo.emptyInstance;
    try {
      final String docId = await getFirebaseDocId(docRef);
      final informationSnapShot = await _deviceInfoCollection.doc(docId).get();
      if (informationSnapShot.exists) {
        currentDeviceInfo =
            informationSnapShot.data() ?? DeviceInfo.emptyInstance;
      }
      return currentDeviceInfo;
    } catch (e) {
      log(e.toString());
      return currentDeviceInfo;
    }
  }

  @override
  Future<String> getFirebaseDocId(String docRef) async {
    var docId = '';
    try {
      final List<String> pathList = docRef.split("/");
      if (pathList.isNotEmpty && pathList.length >= 2) {
        docId = pathList[1];
      }
      return docId;
    } catch (e) {
      log(e.toString());
      return docId;
    }
  }

  static const String DEVICE_INFO_COLLECTION = "deviceInfo";
}
