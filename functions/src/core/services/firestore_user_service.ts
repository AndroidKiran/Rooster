import {CollectionReference, getFirestore} from "firebase-admin/firestore";
import {COLLECTION_USER} from "../../constants";
import {FirebaseEntity, dataConverter} from "../entities/firebase_entity";
import {User} from "../entities/user";

class FirestoreUserService {
  private collection(): CollectionReference<FirebaseEntity<User>> {
    return getFirestore()
    .collection(COLLECTION_USER)
    .withConverter(dataConverter<User>());
  }

  async getOnCallUsers(
    platform: string
  ): Promise<User[]> {
    const querySnapShot = await this.collection()
    .where("isOnCall", "==", true)
    .where("platform", "==", platform)
    .get();
    return querySnapShot.docs.map((data) => data.data().entity);
  }
}

export const firestoreUserService: FirestoreUserService = new FirestoreUserService();

