import {BaseEntity} from "./base_entity";

export class User implements BaseEntity<User> {
  email: string;
  name: string;
  platform: string;
  deviceInfoRef: string;
  isOnCall: boolean;

  constructor(
    email: string,
    name: string,
    platform: string,
    deviceInfoRef: string,
    isOnCall: boolean) {
    this.email = email;
    this.name = name;
    this.platform = platform;
    this.deviceInfoRef = deviceInfoRef;
    this.isOnCall = isOnCall;
  }


  toDocument(): FirebaseFirestore.DocumentData {
    return {
      email: this.email,
      name: this.name,
      platform: this.platform,
      deviceInfoRef: this.deviceInfoRef,
      isOnCall: this.isOnCall,
    };
  }

  static fromDocument(
    snapshot: FirebaseFirestore.QueryDocumentSnapshot
  ): User {
    const data = snapshot.data() as User;
    return new User(
      data.email,
      data.name,
      data.platform,
      data.deviceInfoRef,
      data.isOnCall
    );
  }
}
