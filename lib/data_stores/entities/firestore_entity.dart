import 'package:equatable/equatable.dart';

class FireStoreEntity<T> extends Equatable {
  final String id;
  final T entity;

  const FireStoreEntity({required this.id, required this.entity});

  @override
  List<Object?> get props => [id, entity];
}
