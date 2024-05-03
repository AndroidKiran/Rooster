export interface BaseEntity<T> {
    toDocument<T>(): FirebaseFirestore.DocumentData;
}
