
import {sendVelocityNotification, writeToVelocityCrashDb} from "./velocity_alert/index";
import {onVelocityAlertPublished} from "firebase-functions/v2/alerts/crashlytics";
import {onDocumentCreated} from "firebase-functions/v2/firestore";
import {setGlobalOptions} from "firebase-functions/v2";
import {initializeApp} from "firebase-admin/app";

initializeApp();
setGlobalOptions({maxInstances: 10});

const velocityCrashAlertPath = "/velocityCrashAlerts/{documentId}";
const IOS_APP_ID = "firebase_app_id_here";
const ANDROID_APP_ID = "firebase_app_id_here";

exports.sendOnVelocityAlert = onVelocityAlertPublished(IOS_APP_ID, async (event: any) => {
  return await writeToVelocityCrashDb(IOS_APP_ID, event);
});

exports.sendOnVelocityAlert = onVelocityAlertPublished(ANDROID_APP_ID, async (event: any) => {
  return await writeToVelocityCrashDb(ANDROID_APP_ID, event);
});

exports.sendNoftifcationToOncallUser = onDocumentCreated(velocityCrashAlertPath, async (event: any) => {
  return await sendVelocityNotification(event);
});
