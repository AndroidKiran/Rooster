/// An abstract class that defines a contract for converting objects
/// of type `T` to Firestore documents represented as `Map<String,dynamic>`.
///
/// Classes implementing this interface provide a way to transform
/// data models into a format suitable for storing in Firestore.
library;

abstract class DocumentConverter<F, T> {
  Map<String, dynamic> toDocument(T model);
}
