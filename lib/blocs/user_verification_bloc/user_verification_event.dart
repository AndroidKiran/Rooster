import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:rooster/data_stores/entities/user_entity.dart';

sealed class UserVerificationEvent extends Equatable {}

@immutable
final class VerifyUserExistsEvent extends UserVerificationEvent {
  final UserEntity user;

  VerifyUserExistsEvent({required this.user});

  @override
  List<Object?> get props => [user];
}
