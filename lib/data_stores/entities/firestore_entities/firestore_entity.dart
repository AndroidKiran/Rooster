import 'package:equatable/equatable.dart';

/// A generic base class for representing entities stored in Firestore.
///
/// This class combines a Firestore document ID with the actual entity
/// object and provides value comparison using the `equatable` package.

class FireStoreEntity<T> extends Equatable {
  final String id;
  final T entity;

  const FireStoreEntity({required this.id, required this.entity});

  @override
  List<Object?> get props => [id, entity];
}
