import 'package:equatable/equatable.dart';

/// Represents a form item within a BLoC (Business Logic Component) pattern.
///
/// Each [BlocFormItem] contains an optional error message and the current
/// value of the form item.
///
/// This class extends [Equatable] for easy comparison.

class BlocFormItem extends Equatable {
  final String? error;
  final String? value;

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
