import {firestore} from "firebase-admin";
import {BaseEntity} from "./base_entity";

export class FirebaseEntity<T> {
  id: string;
  entity: T;

  constructor(id: string, entity: T) {
    this.id = id,
    this.entity = entity;
  }
}

export const dataConverter = <T>(): firestore.FirestoreDataConverter<FirebaseEntity<T>> => ({

  toFirestore(data: FirebaseEntity<T>): firestore.DocumentData {
    const baseEntity = data.entity as BaseEntity<T>;
    return baseEntity.toDocument;
  },

  fromFirestore(snapshot: firestore.QueryDocumentSnapshot): FirebaseEntity<T> {
    const data = snapshot.data() as T;
    return {
      id: snapshot.id,
      entity: data,
    };
  },
});
