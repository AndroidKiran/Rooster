import 'package:cloud_firestore/cloud_firestore.dart';

abstract class DocumentConverter<F, T> {
  Map<String, dynamic> toDocument(T model);

// F fromDocument(DocumentSnapshot<Map<String, dynamic>> snapshot);
}
