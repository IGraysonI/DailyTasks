import 'package:meta/meta.dart';

/// Pattern matching for [StateBase].
typedef StateBaseMatch<R, T> = R Function(T state);

/// {@template state_base}
/// Base class for all states in the application that are using Control package
/// {@endtemplate}
@immutable
abstract base class StateBase<T> {
  /// {@macro state_base}
  const StateBase({required this.message});

  /// Message or state description.
  @nonVirtual
  final String message;

  /// Error message.
  abstract final String? error;

  /// If an error has occurred.
  bool get hasError => error != null;

  /// Is in processing state.
  bool get isProcessing => maybeMap<bool>(orElse: () => false, processing: (_) => true);

  /// Is in idle state.
  bool get isIdle => !isProcessing;

  /// Pattern matching for state.
  R map<R>({
    required StateBaseMatch<R, T> idle,
    required StateBaseMatch<R, T> processing,
  });

  /// Pattern matching for state.
  R maybeMap<R>({
    required R Function() orElse,
    StateBaseMatch<R, T> idle,
    StateBaseMatch<R, T> processing,
  });

  /// Pattern matching for state.\
  R? mapOrNull<R>({
    StateBaseMatch<R, T> idle,
    StateBaseMatch<R, T> processing,
  });

  /// Copy with method for state.
  StateBase<T> copyWith({
    String? message,
  });

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  bool operator ==(Object other) => identical(this, other);

  @override
  String toString() {
    final buffer = StringBuffer()
      ..write('message: $message')
      ..write(')');
    return buffer.toString();
  }
}
