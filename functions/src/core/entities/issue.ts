
import {CrashlyticsEvent, NewFatalIssuePayload, VelocityAlertPayload} from "firebase-functions/v2/alerts/crashlytics";
import {BaseEntity} from "./base_entity";

export class Issue implements BaseEntity<Issue> {
  type: string;
  crashCount: number;
  crashPercentage: number;
  createTime: string;
  firstVersion: string;
  appVersion: string;
  issueId: string;
  subtitle: string;
  title: string;
  projectName: string;
  platform: string;
  appId: string;
  visitedUserId: string;

  constructor(
    type: string,
    crashCount: number,
    crashPercentage: number,
    createTime: string,
    firstVersion: string,
    appVersion: string,
    issueId: string,
    subtitle: string,
    title: string,
    projectName: string,
    platform: string,
    appId: string,
    visitedUserId: string
  ) {
    this.type = type,
    this.crashCount = crashCount,
    this.crashPercentage = crashPercentage,
    this.createTime = createTime,
    this.firstVersion = firstVersion,
    this.appVersion = appVersion,
    this.issueId = issueId,
    this.subtitle = subtitle,
    this.title = title,
    this.projectName = projectName,
    this.platform = platform,
    this.appId = appId;
    this.visitedUserId = visitedUserId;
  }

  toDocument(): FirebaseFirestore.DocumentData {
    return {
      type: this.type,
      crashCount: this.crashCount,
      crashPercentage: this.crashPercentage,
      createTime: this.createTime,
      firstVersion: this.firstVersion,
      appVersion: this.appVersion,
      issueId: this.issueId,
      subtitle: this.subtitle,
      title: this.title,
      projectName: this.projectName,
      platform: this.platform,
      appId: this.appId,
      visitedUserId: this.visitedUserId,
    };
  }

  static fromDocument(snapshot: FirebaseFirestore.QueryDocumentSnapshot): Issue {
    return snapshot.data() as Issue;
  }

  static fromVelocityAlertEvent(event: CrashlyticsEvent<VelocityAlertPayload>): Issue {
    const IOS_APP_ID = "ios";
    const ANDROID_APP_ID = "android";
    const payload:VelocityAlertPayload = event.data.payload;
    const typeArr = payload["@type"].split(".");
    const type = typeArr[typeArr.length - 1];
    const issue = payload.issue;
    let platform = "";
    if (event.appId.includes(IOS_APP_ID)) {
      platform = IOS_APP_ID;
    }
    if (event.appId.includes(ANDROID_APP_ID)) {
      platform = ANDROID_APP_ID;
    }
    return new Issue(
      type,
      payload.crashCount,
      payload.crashPercentage,
      payload.createTime,
      payload.firstVersion,
      issue.appVersion,
      issue.id,
      issue.subtitle,
      issue.title,
      "",
      platform,
      event.appId,
      ""
    );
  }

  static fromFatalIssueEvent(event: CrashlyticsEvent<NewFatalIssuePayload>): Issue {
    const IOS_APP_ID = "ios";
    const ANDROID_APP_ID = "android";
    const payload:NewFatalIssuePayload = event.data.payload;
    const typeArr = payload["@type"].split(".");
    const type = typeArr[typeArr.length - 1];
    const issue = payload.issue;
    let platform = "";
    if (event.appId.includes(IOS_APP_ID)) {
      platform = IOS_APP_ID;
    }
    if (event.appId.includes(ANDROID_APP_ID)) {
      platform = ANDROID_APP_ID;
    }
    return new Issue(
      type,
      0,
      0,
      "",
      "",
      issue.appVersion,
      issue.id,
      issue.subtitle,
      issue.title,
      "",
      platform,
      event.appId,
      ""
    );
  }
}

