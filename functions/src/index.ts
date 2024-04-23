import {initializeApp} from "firebase-admin/app";
import {ParamsOf, setGlobalOptions} from "firebase-functions/v2";

initializeApp();
setGlobalOptions({maxInstances: 10});

import {sendVelocityNotification, writeToFatalCrashDb, writeToVelocityCrashDb} from "./velocity_alert/index";
import {onVelocityAlertPublished, onNewFatalIssuePublished, CrashlyticsEvent, NewFatalIssuePayload, VelocityAlertPayload} from "firebase-functions/v2/alerts/crashlytics";
import {onDocumentCreated, FirestoreEvent, QueryDocumentSnapshot} from "firebase-functions/v2/firestore";

const velocityCrashAlertPath = "/velocityCrashAlerts/{documentId}";

exports.sendOnVelocityAlert = onNewFatalIssuePublished(async (event: CrashlyticsEvent<NewFatalIssuePayload>) => {
  return await writeToFatalCrashDb(event);
});

exports.sendOnVelocityAlert = onVelocityAlertPublished(async (event: CrashlyticsEvent<VelocityAlertPayload>) => {
  return await writeToVelocityCrashDb(event);
});

exports.sendNoftifcationToOncallUser = onDocumentCreated(velocityCrashAlertPath, async (event: FirestoreEvent<QueryDocumentSnapshot | undefined, ParamsOf<string>>) => {
  return await sendVelocityNotification(event);
});
