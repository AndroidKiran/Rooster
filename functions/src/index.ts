import {initializeApp} from "firebase-admin/app";
import {setGlobalOptions} from "firebase-functions/v2";

initializeApp();
setGlobalOptions({maxInstances: 10});

import {eventTriggers} from "./event_triggers";


// import {sendVelocityNotification, writeToFatalCrashDb, writeToVelocityCrashDb} from "./velocity_alert/index";
// import {onVelocityAlertPublished, onNewFatalIssuePublished, CrashlyticsEvent, NewFatalIssuePayload, VelocityAlertPayload} from "firebase-functions/v2/alerts/crashlytics";
// import {onDocumentCreated, FirestoreEvent, QueryDocumentSnapshot} from "firebase-functions/v2/firestore";

// const velocityCrashAlertPath = "/velocityCrashAlerts/{documentId}";

// exports.sendOnVelocityAlert = onNewFatalIssuePublished(async (event: CrashlyticsEvent<NewFatalIssuePayload>) => {
//   await writeToFatalCrashDb(event);
// });

// exports.sendOnVelocityAlert = onVelocityAlertPublished(async (event: CrashlyticsEvent<VelocityAlertPayload>) => {
//   await writeToVelocityCrashDb(event);
// });

// exports.sendNoftifcationToOncallUser = onDocumentCreated(issuePath, async (event: FirestoreEvent<QueryDocumentSnapshot | undefined, ParamsOf<string>>) => {
//   await sendVelocityNotification(event);
// });

Object.assign(exports, eventTriggers());
