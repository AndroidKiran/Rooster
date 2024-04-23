import {initializeApp} from "firebase-admin/app";
import {setGlobalOptions} from "firebase-functions/v2";

initializeApp();
setGlobalOptions({maxInstances: 10});

import { getApp } from "firebase/app";
import { getFunctions, connectFunctionsEmulator } from "firebase/functions";

const functions = getFunctions(getApp());
connectFunctionsEmulator(functions, "127.0.0.1", 5001);

import {sendVelocityNotification, writeToVelocityCrashDb} from "./velocity_alert/index";
import {onVelocityAlertPublished, onNewFatalIssuePublished} from "firebase-functions/v2/alerts/crashlytics";
import {onDocumentCreated} from "firebase-functions/v2/firestore";

const velocityCrashAlertPath = "/velocityCrashAlerts/{documentId}";
const IOS_APP_ID = "firebase_app_id_here";
const ANDROID_APP_ID = "firebase_app_id_here";

exports.sendOnVelocityAlert = onNewFatalIssuePublished(async (event: any) => {
  return await writeToVelocityCrashDb(IOS_APP_ID, event);
});

exports.sendOnVelocityAlert = onVelocityAlertPublished(async (event: any) => {
  return await writeToVelocityCrashDb(IOS_APP_ID, event);
});

exports.sendOnVelocityAlert = onVelocityAlertPublished(ANDROID_APP_ID, async (event: any) => {
  return await writeToVelocityCrashDb(ANDROID_APP_ID, event);
});

exports.sendNoftifcationToOncallUser = onDocumentCreated(velocityCrashAlertPath, async (event: any) => {
  return await sendVelocityNotification(event);
});
