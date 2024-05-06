import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:rooster/data_stores/entities/device_info.dart';
import 'package:rooster/data_stores/entities/firestore_entities/firestore_device_info.dart';
import 'package:rooster/data_stores/entities/firestore_entities/firestore_issue_info.dart';
import 'package:rooster/data_stores/entities/firestore_entities/firestore_entity.dart';
import 'package:rooster/data_stores/entities/issue_info.dart';
import 'package:rooster/data_stores/entities/user_entity.dart';

class FirebaseManager {
  late FirebaseFirestore fireStore = _roosterFireStore();
  late FirebaseMessaging firebaseMessaging = _roosterFirebaseMessaging();
  late CollectionReference<UserEntity> userDb = _userFireStoreCollection();
  late CollectionReference<FirestoreIssueInfo> issueDb =
      _issuesFireStoreCollection();
  late CollectionReference<FirestoreDeviceInfo> deviceInfoDb =
      _deviceFireStoreCollection();

  static final FirebaseManager _singleton = FirebaseManager._();

  factory FirebaseManager() => _singleton;

  FirebaseManager._();

  Future<void> setupFirebase() async {
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: false,
      sound: true,
    );
  }

  FirebaseFirestore _roosterFireStore() {
    FirebaseFirestore firebaseFireStore = FirebaseFirestore.instance;
    if (kDebugMode) {
      try {
        firebaseFireStore.useFirestoreEmulator('localhost', 8080);
      } catch (e) {
        print(e);
      }
    }
    firebaseFireStore.settings = const Settings(
        persistenceEnabled: true,
        cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
        sslEnabled: false);
    return firebaseFireStore;
  }

  FirebaseMessaging _roosterFirebaseMessaging() {
    return FirebaseMessaging.instance;
  }

  bool isIssueNotification(RemoteMessage message) {
    return message.data.containsKey(KEY_NOTIFICATION_TYPE) &&
        message.data[KEY_NOTIFICATION_TYPE] == VALUE_NOTIFICATION_TYPE;
  }

  bool hasValidIssueId(RemoteMessage message) {
    return message.data.containsKey(KEY_ISSUE_ID) &&
        message.data[KEY_ISSUE_ID] != null;
  }

  CollectionReference<UserEntity> _userFireStoreCollection() =>
      fireStore.collection(USER_COLLECTION).withConverter(
          fromFirestore: (snapshot, _) => UserEntity.fromJson(snapshot.data()!),
          toFirestore: (userEntity, _) => userEntity.toJson());

  // CollectionReference<DeviceInfo> _deviceFireStoreCollection() =>
  //     fireStore.collection(DEVICE_INFO_COLLECTION).withConverter(
  //         fromFirestore: (snapshot, _) => DeviceInfo.fromJson(snapshot.data()!),
  //         toFirestore: (deviceInfo, _) => deviceInfo.toJson());

  CollectionReference<FirestoreDeviceInfo>
      _deviceFireStoreCollection() => fireStore
          .collection(DEVICE_INFO_COLLECTION)
          .withConverter<FirestoreDeviceInfo>(
              fromFirestore:
                  (snapshot, _) => FirestoreDeviceInfo.fromDocument(snapshot),
              toFirestore: (firestoreDeviceInfo, _) =>
                  firestoreDeviceInfo.toDocument(firestoreDeviceInfo.entity));

  CollectionReference<FirestoreIssueInfo> _issuesFireStoreCollection() =>
      fireStore.collection(ISSUE_COLLECTION).withConverter<FirestoreIssueInfo>(
          fromFirestore: (snapshot, _) =>
              FirestoreIssueInfo.fromDocument(snapshot),
          toFirestore: (firestoreIssueInfo, _) =>
              firestoreIssueInfo.toDocument(firestoreIssueInfo.entity));

  static const String VALUE_NOTIFICATION_TYPE = "voipNotificationType";
  static const String KEY_NOTIFICATION_TYPE = "notificationType";
  static const String KEY_ISSUE_ID = "issueId";
  static const String USER_COLLECTION = "users";
  static const String ISSUE_COLLECTION = "issues";
  static const String DEVICE_INFO_COLLECTION = "deviceInformations";
}
