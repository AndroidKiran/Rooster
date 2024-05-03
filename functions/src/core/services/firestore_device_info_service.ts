import {CollectionReference, DocumentSnapshot, WriteResult, getFirestore} from "firebase-admin/firestore";
import {COLLECTION_DEVICE_INFO} from "../../constants";
import {DeviceInfo} from "../entities/device_info";
import {BatchResponse} from "firebase-admin/messaging";
import {FirebaseEntity, dataConverter} from "../entities/firebase_entity";

const errorCodeInvalidRegToken = "messaging/invalid-registration-token";
const errrCodeRegTokenNotRegistered = "messaging/registration-token-not-registered";
const errorCodeInvalidArgument = "messaging/invalid-argument";
const errorFcmMessage = "The registration token is not a valid FCM registration token";

class FirestoreDeviceInfoService {
  private collection(): CollectionReference<FirebaseEntity<DeviceInfo>> {
    return getFirestore().collection(COLLECTION_DEVICE_INFO).withConverter(dataConverter<DeviceInfo>());
  }

  async getAllDeviceToken(docPath: string[]): Promise<FirebaseEntity<DeviceInfo>[]> {
    const deviceInfoDocumentSnapshots:Promise<DocumentSnapshot<FirebaseEntity<DeviceInfo>>>[] = [];
    docPath.forEach((path) => {
      const pathTokens = path.split("/");
      if (pathTokens.length == 2) {
        deviceInfoDocumentSnapshots.push(this.collection().doc(pathTokens[1]).get());
      }
    });
    const values = await Promise.all(deviceInfoDocumentSnapshots);
    return values.map((doc) => doc.data()!);
  }

  async deleteAllDeviceInfo(ids: string[]): Promise<WriteResult[]> {
    const deviceInfoDeleteResults:Promise<WriteResult>[] = [];
    ids.forEach((id) => {
      const deleteResult: Promise<WriteResult> = this.collection().doc(id).delete();
      deviceInfoDeleteResults.push(deleteResult);
    });
    return Promise.all(deviceInfoDeleteResults);
  }


  async cleanUpTokens(
    batchResponse: BatchResponse,
    docIds: string[]
  ): Promise<FirebaseFirestore.WriteResult[]> {
    const tokensDelete: Promise<FirebaseFirestore.WriteResult>[] = [];
    batchResponse.responses.forEach((result, index) => {
      const error = result.error;
      if (error) {
        // Cleanup the tokens that are not registered anymore.
        if ((error.code === errorCodeInvalidRegToken) ||
          (error.code === errrCodeRegTokenNotRegistered) ||
          (error.code === errorCodeInvalidArgument && error.message === errorFcmMessage)) {
          const deleteTask: Promise<FirebaseFirestore.WriteResult> = this.collection().doc(docIds[index]).delete();
          tokensDelete.push(deleteTask);
        }
      }
    });
    return Promise.all(tokensDelete);
  }
}

export const firestoreDeviceInfoService: FirestoreDeviceInfoService = new FirestoreDeviceInfoService();
