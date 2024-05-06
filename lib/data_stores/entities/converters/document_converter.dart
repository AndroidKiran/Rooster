
abstract class DocumentConverter<F, T> {
  Map<String, dynamic> toDocument(T model);

// F fromDocument(DocumentSnapshot<Map<String, dynamic>> snapshot);
}
