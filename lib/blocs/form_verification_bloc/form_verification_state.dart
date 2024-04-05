part of 'form_verification_bloc.dart';

enum FormStatus {
  init,
  formSubmitting,
  submitSuccess,
  submitFailure;
}

class FormVerificationState extends Equatable {
  final FormStatus formStatus;
  final UserEntity user;

  const FormVerificationState._({
    this.formStatus = FormStatus.init,
    this.user = UserEntity.emptyInstance
  });

  const FormVerificationState.init() : this._();

  const FormVerificationState.submitting() : this._(
      formStatus: FormStatus.formSubmitting,
      user: UserEntity.emptyInstance
  );

  const FormVerificationState.submitSuccess(UserEntity user) : this._(
      formStatus: FormStatus.submitSuccess,
      user: user
  );

  const FormVerificationState.submitFailure() : this._(
      formStatus: FormStatus.submitFailure,
      user: UserEntity.emptyInstance
  );

  FormVerificationState copyWith({
    FormStatus? formStatus,
    UserEntity? user
  }) {
    return FormVerificationState._(
        formStatus: formStatus ?? this.formStatus,
        user: user ?? this.user
    );
  }

  @override
  List<Object?> get props => [formStatus, user];
}

