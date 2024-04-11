
import {CollectionReference, DocumentReference, DocumentSnapshot, Firestore, Query, QuerySnapshot, getFirestore} from "firebase-admin/firestore";
import {BatchResponse, Message, Messaging, getMessaging} from "firebase-admin/messaging";
import {logger} from "firebase-functions";
import {COLLECTION_USER, DEVICE_INFO, VELOCITY_CRASH_ALERT} from "../constants";
import {isEmptyString} from "../utils";

const firestore: Firestore = getFirestore();
const messaging: Messaging = getMessaging();
const userCollection: CollectionReference = firestore.collection(COLLECTION_USER);
const velocityCrashAlertsCollection: CollectionReference = firestore.collection(VELOCITY_CRASH_ALERT);

const errorCodeInvalidRegToken = "messaging/invalid-registration-token";
const errrCodeRegTokenNotRegistered = "messaging/registration-token-not-registered";
const errorCodeInvalidArgument = "messaging/invalid-argument";
const errorFcmMessage = "The registration token is not a valid FCM registration token";

/**
 * function write the event into velcoity alert db
 * @param {string} appid - is to identify velocity crash on app
 * @param {any} event - is for event
 * @return {Promise} promise
 */
export async function writeToVelocityCrashDb(appid:string, event: any) {
  logger.log("onVelocityAlertPublished executing");
  logger.log("app_id==", appid);
  logger.log("event_data==", event.data.payload);

  const {crashCount, crashPercentage, createTime, firstVersion} = event.data.payload;
  const {id, title, subtitle, appVersion} = event.data.payload.issue;

  const crashlyticsData = {
    "appId": appid,
    "issueId": id,
    "issueTitle": title,
    "issueSubtitle": subtitle,
    "appVersion": appVersion,
    "crashCount": crashCount,
    "crashPercentage": crashPercentage,
    "createdAt": createTime,
    "firstVersion": firstVersion,
  };

  // Write the event data on db
  const docRef: DocumentReference = velocityCrashAlertsCollection.doc(id);
  return await docRef.set(crashlyticsData);
}

/**
 * function send velocity alert notification to on call user
 * @param {any} event - is for event
 * @return {Promise}
 */
export async function sendVelocityNotification(event: any) {
  logger.log("onDocumentCreated executing");
  const snapshot = event.data;
  if (!snapshot) {
    logger.log("No data associated with the event");
    return;
  }
  const appId = snapshot.appId;
  if (isEmptyString(appId)) {
    logger.log("app id is empty");
    return;
  }

  const deviceInfoDocumentSnapshots: DocumentSnapshot<FirebaseFirestore.DocumentData>[] = await getAllUserDeviceInfo(appId);
  const deviceInfoDocumentSnapshotExists = deviceInfoDocumentSnapshots.length > 0;

  if (!deviceInfoDocumentSnapshotExists) {
    logger.log("device info list is empty");
    return;
  }

  const tokens: string[] = deviceInfoDocumentSnapshots.map((doc) => {
    const snapshot = doc.data();
    if (snapshot) {
      return snapshot.fcmToken;
    }
  });

  const messages: Message[] = [];
  tokens.forEach((fcmToken) => {
    messages.push({
      token: fcmToken,
      notification: {
        title: snapshot.issueTitle,
        body: snapshot.issueSubTitle,
      },
      data: {
        type: "CrashVelocityNotificationType",
        issueId: snapshot.issueId,
      },
    });
  });

  const messageExists = messages.length > 0;
  if (messageExists) {
    const batchResponse: BatchResponse = await messaging.sendEach(messages);
    if (batchResponse.failureCount < 1) {
      logger.log("${batchResponse.failureCount} message sent.", batchResponse);
      return;
    }
    logger.log("${batchResponse.failureCount} messages failed to sent", batchResponse);
    return await cleanUpTokens(batchResponse, deviceInfoDocumentSnapshots);
  } else {
    logger.log("notifcation message is empty");
    return Promise.resolve();
  }
}

/**
 * function get device information of on call users
 * @param {string} appId - is for querying the db
 * @return {Promise}
 */
async function getAllUserDeviceInfo(appId: string): Promise<DocumentSnapshot[]> {
  const userQuerySnapShot: QuerySnapshot = await getOnCallUsers(appId);
  const usersExists: boolean = userQuerySnapShot.docs.length > 0;
  if (usersExists) {
    const deviceInfos: string[] = userQuerySnapShot.docs.map((doc) => doc.data().deviceInfo);
    const deviceInfoDocumentSnapshots: DocumentSnapshot[] = [];
    deviceInfos.forEach(async (deviceInfo) => {
      const deviceInfoDocSnapShot: DocumentSnapshot = await firestore.doc(deviceInfo).get();
      deviceInfoDocumentSnapshots.push(deviceInfoDocSnapShot);
    });
    return deviceInfoDocumentSnapshots;
  } else {
    logger.log("on call user list is empty");
    return [];
  }
}

async function getOnCallUsers(appId: string): Promise<QuerySnapshot> {
  let platform = "";

  if (appId == "IOS") {
    platform = "ios";
  }

  if (appId == "android") {
    platform = "android";
  }

  const userQuery: Query = userCollection.where("isOnCall", "==", true).where("platform", "==", platform);
  return await userQuery.get();
}

/**
 * function cleanup the invalid tokens saved on db
 * @param {BatchResponse} batchResponse - is bacth response of notifcations sent
 * @param {DocumentSnapshot<FirebaseFirestore.DocumentData>[]} deviceInfoDocumentSnapshots - is list of device info snapshot
 * @return {Promise}
 */
async function cleanUpTokens(
  batchResponse: BatchResponse,
  deviceInfoDocumentSnapshots: DocumentSnapshot<FirebaseFirestore.DocumentData>[]
): Promise<FirebaseFirestore.WriteResult[]> {
  // For each notification we check if there was an error.
  const deviceInfoIds: string[] = deviceInfoDocumentSnapshots.map((doc) => doc.id);
  const tokensDelete: Promise<FirebaseFirestore.WriteResult>[] = [];
  batchResponse.responses.forEach((result, index) => {
    const error = result.error;
    if (error) {
      logger.error("Failure sending notification to", deviceInfoIds[index], error);
      // Cleanup the tokens that are not registered anymore.
      if ((error.code === errorCodeInvalidRegToken) ||
        (error.code === errrCodeRegTokenNotRegistered) ||
        (error.code === errorCodeInvalidArgument && error.message === errorFcmMessage)) {
        const deleteTask: Promise<FirebaseFirestore.WriteResult> = firestore.collection(DEVICE_INFO).doc(deviceInfoIds[index]).delete();
        tokensDelete.push(deleteTask);
      }
    }
  });
  return Promise.all(tokensDelete);
}
