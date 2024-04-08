import 'package:equatable/equatable.dart';

class BlocFormItem extends Equatable {
  final String? error;
  final String value;

  const BlocFormItem({this.error, this.value = ''});

  BlocFormItem copyWith({
    String? error,
    String? value,
  }) {
    return BlocFormItem(
      error: error ?? this.error,
      value: value ?? this.value,
    );
  }

  @override
  List<Object?> get props => [error, value];
}
