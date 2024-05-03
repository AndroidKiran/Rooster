import {BaseEntity} from "./base_entity";

export class DeviceInfo implements BaseEntity<DeviceInfo> {
  fcmToken: string;
  os: string;

  constructor(fcmToken: string, os: string) {
    this.fcmToken = fcmToken,
    this.os = os;
  }

  toDocument(): FirebaseFirestore.DocumentData {
    return {
      fcmToken: this.fcmToken,
      os: this.os,
    };
  }

  static fromDocument(snapshot: FirebaseFirestore.QueryDocumentSnapshot<FirebaseFirestore.DocumentData, FirebaseFirestore.DocumentData>): DeviceInfo {
    const data = snapshot.data() as DeviceInfo;
    return new DeviceInfo(
      data.fcmToken,
      data.os
    );
  }
}
