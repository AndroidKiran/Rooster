import {CollectionReference, getFirestore} from "firebase-admin/firestore";
import {Issue} from "../entities/issue";
import {FirebaseEntity, dataConverter} from "../entities/firebase_entity";
import {COLLECTION_ISSUE} from "../../constants";

class FirestoreIssueService {
  private collection(): CollectionReference<FirebaseEntity<Issue>> {
    return getFirestore().collection(COLLECTION_ISSUE).withConverter(dataConverter<Issue>());
  }

  async addIssue(crash: Issue): Promise<FirebaseFirestore.WriteResult> {
    const firebaseEntity: FirebaseEntity<Issue> = new FirebaseEntity<Issue>(
      crash.issueId,
      crash
    );
    return this.collection().doc(firebaseEntity.id).set(firebaseEntity);
  }
}

export const firestoreIssueService: FirestoreIssueService = new FirestoreIssueService();
