import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:rooster/data_stores/entities/user_entity.dart';

@immutable
sealed class FormSubmissionStatus extends Equatable {}
class FormSubmissionInit extends FormSubmissionStatus {
  @override
  List<Object?> get props => [];
}
final class FormSubmitting extends FormSubmissionStatus {
  @override
  List<Object?> get props => [];
}

final class SubmissionSuccess extends FormSubmissionStatus {
  final UserEntity user;

  SubmissionSuccess({required this.user});

  @override
  List<Object?> get props => [];
}

final class SubmissionFailed extends FormSubmissionStatus {
  final Exception exception;
  SubmissionFailed(this.exception);

  @override
  List<Object?> get props => [exception];
}