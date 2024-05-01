
import {CollectionReference, DocumentReference, DocumentSnapshot, Firestore, Query, QuerySnapshot, getFirestore} from "firebase-admin/firestore";
import {BatchResponse, Message, Messaging, getMessaging} from "firebase-admin/messaging";
import {logger} from "firebase-functions";
import {COLLECTION_USER, DEVICE_INFO, VELOCITY_CRASH_ALERT} from "../constants";
import {isEmptyString} from "../utils";
import {FirestoreEvent, QueryDocumentSnapshot} from "firebase-functions/v2/firestore";
import {ParamsOf} from "firebase-functions/v2";
import {CrashlyticsEvent, VelocityAlertPayload, NewFatalIssuePayload} from "firebase-functions/v2/alerts/crashlytics";


const firestore: Firestore = getFirestore();
const messaging: Messaging = getMessaging();
const userCollection: CollectionReference = firestore.collection(COLLECTION_USER);
const velocityCrashAlertsCollection: CollectionReference = firestore.collection(VELOCITY_CRASH_ALERT);

const errorCodeInvalidRegToken = "messaging/invalid-registration-token";
const errrCodeRegTokenNotRegistered = "messaging/registration-token-not-registered";
const errorCodeInvalidArgument = "messaging/invalid-argument";
const errorFcmMessage = "The registration token is not a valid FCM registration token";

const IOS_APP_ID = "ios";
const ANDROID_APP_ID = "android";

/**
 * function write the event into velcoity alert db
 * @param {CrashlyticsEvent<VelocityAlertPayload>} event - is for event
 */
export async function writeToVelocityCrashDb(event: CrashlyticsEvent<VelocityAlertPayload>) {
  logger.log("onVelocityAlertPublished executing");
  logger.log("app_id==", event.appId);
  logger.log("event_data==", event.data.payload);

  const {crashCount, crashPercentage, createTime, firstVersion} = event.data.payload;
  const {id, title, subtitle, appVersion} = event.data.payload.issue;

  let platform = "";
  if (event.appId.includes(IOS_APP_ID)) {
    platform = IOS_APP_ID;
  }

  if (event.appId.includes(ANDROID_APP_ID)) {
    platform = ANDROID_APP_ID;
  }

  if (isEmptyString(platform)) {
    return;
  }

  const crashlyticsData = {
    "appId": event.appId,
    "issueId": id,
    "issueTitle": title,
    "issueSubtitle": subtitle,
    "appVersion": appVersion,
    "crashCount": crashCount,
    "crashPercentage": crashPercentage,
    "createdAt": createTime,
    "firstVersion": firstVersion,
    "platform": platform,
  };

  // Write the event data on db
  const docRef: DocumentReference = velocityCrashAlertsCollection.doc(id);
  await docRef.set(crashlyticsData);
}

/**
 * function write the event into velcoity alert db
 * @param {CrashlyticsEvent<NewFatalIssuePayload>} event - is for event
 */
export async function writeToFatalCrashDb(event: CrashlyticsEvent<NewFatalIssuePayload>) {
  logger.log("onVelocityAlertPublished executing");
  logger.log("app_id==", event.appId);
  logger.log("event_data==", event.data.payload);
  return;
}

/**
 * function send velocity alert notification to on call user
 * @param {FirestoreEvent<QueryDocumentSnapshot | undefined, ParamsOf<string>>} event - is for event
 */
export async function sendVelocityNotification(event: FirestoreEvent<QueryDocumentSnapshot | undefined, ParamsOf<string>>) {
  logger.log("onDocumentCreated executing");
  const snapshot = event.data;
  if (!snapshot) {
    logger.log("No data associated with the event");
    return;
  }

  const data = snapshot.data();
  if (!data) {
    logger.log("Invalid issue data");
    return;
  }

  const platform = data.platform;
  if (isEmptyString(platform)) {
    logger.log("platform is empty");
    return;
  }

  const deviceInfoDocumentSnapshots: DocumentSnapshot<FirebaseFirestore.DocumentData>[] = await getAllUserDeviceInfo(platform);
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

  logger.log("token list ==> "+tokens);

  const messages: Message[] = [];
  tokens.forEach((fcmToken) => {
    messages.push({
      token: fcmToken,
      notification: {
        title: data.issueTitle,
        body: data.issueSubTitle,
      },
      data: {
        type: "CrashVelocityNotificationType",
        issueId: data.issueId,
      },
    });
  });

  const messageExists = messages.length > 0;
  logger.log("message list ==> "+messages);
  if (messageExists) {
    const batchResponse: BatchResponse = await messaging.sendEach(messages);
    if (batchResponse.failureCount < 1) {
      logger.log("message sent count:===> " + batchResponse.successCount);
    } else {
      logger.log("messages failed to sent:==> " + batchResponse.failureCount);
      await cleanUpTokens(batchResponse, deviceInfoDocumentSnapshots);
    }
  } else {
    logger.log("message list is empty ==> "+messages.length);
  }
}

/**
 * function get device information of on call users
 * @param {string} platform - is for querying the db
 * @return {Promise<DocumentSnapshot[]>}
 */
async function getAllUserDeviceInfo(platform: string): Promise<DocumentSnapshot[]> {
  const deviceInfoDocumentSnapshots:Promise<DocumentSnapshot>[] = [];
  const userQuery: Query = userCollection.where("isOnCall", "==", true).where("platform", "==", platform);
  const userQuerySnapShot: QuerySnapshot = await userQuery.get();
  const usersExists: boolean = userQuerySnapShot.docs.length > 0;
  logger.log("on call user list == " + usersExists + " with platform = "+platform);
  if (usersExists) {
    const deviceInfo: string[] = userQuerySnapShot.docs.map((doc) => {
      const data = doc.data();
      if (data) {
        return data.deviceInfoRef;
      }
    });

    const isDeviceInfoExists = deviceInfo.length > 0;

    if (deviceInfo.length > 0) {
      logger.log(" with platform = " +platform + " device info ==  " +deviceInfo[0]);
    }

    if (!isDeviceInfoExists) {
      logger.log(" with platform = " +platform + " device info length ==  " +deviceInfo.length);
      return Promise.resolve([]);
    }

    deviceInfo.forEach((path) => {
      logger.log("deviceinfo path ==  " +path);
      const deviceInfoDocSnapShot = firestore.doc(path).get();
      deviceInfoDocumentSnapshots.push(deviceInfoDocSnapShot);
    });
  }
  return Promise.all(deviceInfoDocumentSnapshots);
}

/**
 * function cleanup the invalid tokens saved on db
 * @param {BatchResponse} batchResponse - is bacth response of notifcations sent
 * @param {DocumentSnapshot<FirebaseFirestore.DocumentData>[]} deviceInfoDocumentSnapshots - is list of device info snapshot
 * @return {Promise<FirebaseFirestore.WriteResult[]>}
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
