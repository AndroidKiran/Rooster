import {BatchResponse, Message, getMessaging} from "firebase-admin/messaging";
import {Issue} from "../entities/issue";

class FirebaseNotificationService {
  async getMessages(issue: Issue, tokens: string[]): Promise<Message[]> {
    const messages: Message[] = [];
    tokens.forEach((fcmToken) => {
      messages.push({
        token: fcmToken,
        notification: {
          title: issue.title,
          body: issue.subtitle,
        },
        data: {
          notificationType: "voipNotificationType",
          issueId: issue.issueId,
        },
      });
    });
    return messages;
  }

  async notifyAll(
    messages: Message[]
  ): Promise<BatchResponse> {
    return getMessaging().sendEach(messages);
  }
}

export const firebaseNotificationService: FirebaseNotificationService = new FirebaseNotificationService();
