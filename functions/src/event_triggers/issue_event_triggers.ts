import {onDocumentCreated} from "firebase-functions/v2/firestore";
import {onVelocityAlertPublished, onNewFatalIssuePublished} from "firebase-functions/v2/alerts/crashlytics";

import {AddEventTrigger, EventTriggerV2Function, InitializeEventTriggers} from "./initialize_event_triggers";
import {Issue} from "../core/entities/issue";
import {firestoreIssueService} from "../core/services/firestore_issue_service";
import {firestoreDeviceInfoService} from "../core/services/firestore_device_info_service";
import {firestoreUserService} from "../core/services/firestore_user_service";
import {User} from "../core/entities/user";
import {DeviceInfo} from "../core/entities/device_info";
import {firebaseNotificationService} from "../core/services/firebase_notification_service";
import {FirebaseEntity} from "../core/entities/firebase_entity";
import {Message} from "firebase-admin/messaging";
import {logger} from "firebase-functions/v2";

const userService = firestoreUserService;
const deviceInfoService = firestoreDeviceInfoService;
const notificationService = firebaseNotificationService;

const issuePath = "/issues/{issueId}";

export class IssueEventTriggers implements InitializeEventTriggers {
  initialize(add: AddEventTrigger): void {
    add(this.onNewFatalIssuePublished);
    add(this.onVelocityIssuePublished);
    add(this.onIssueCreated);
  }

  private readonly onVelocityIssuePublished: EventTriggerV2Function = {
    name: "onVelocityIssuePublished",
    handler: onVelocityAlertPublished(async (event) => {
      const issue: Issue = Issue.fromVelocityAlertEvent(event);
      await firestoreIssueService.addIssue(issue);
    }),
  };

  private readonly onNewFatalIssuePublished: EventTriggerV2Function = {
    name: "onNewFatalIssuePublished",
    handler: onNewFatalIssuePublished(async (event) => {
      const issue: Issue = Issue.fromFatalIssueEvent(event);
      await firestoreIssueService.addIssue(issue);
    }),
  };

  private readonly onIssueCreated: EventTriggerV2Function = {
    name: "onIssueCreated",
    handler: onDocumentCreated(issuePath, async (event) => {
      logger.log("onDocumentCreated started");
      const issue: Issue = Issue.fromDocument(event.data!);
      const users: User[] = await userService.getOnCallUsers(issue.platform);
      const deviceInfoPaths: string[] = users.map((user) => user.deviceInfoRef);
      const deviceInfomations: FirebaseEntity<DeviceInfo>[] = await deviceInfoService.getAllDeviceToken(deviceInfoPaths);
      const tokens: string[] = deviceInfomations.map((deviceInfo) => deviceInfo.entity.fcmToken);
      const messages: Message[] = await notificationService.getMessages(issue, tokens);
      if (messages.length <= 0) return;
      const batchResponse = await notificationService.notifyAll(messages);
      logger.log("onDocumentCreated completed");
      if (batchResponse.failureCount > 0) {
        const docIds: string[] = deviceInfomations.map((deviceInfo) => deviceInfo.id);
        await deviceInfoService.cleanUpTokens(batchResponse, docIds);
      } else {
        Promise.resolve();
      }
    }),
  };
}
