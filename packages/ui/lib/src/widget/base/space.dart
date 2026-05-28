import 'package:flutter/material.dart';

const double _space = 8;

/// {@template space}
/// A widget that represents a space with a specific size.
/// {@endtemplate}
class Space extends StatelessWidget {
  const Space._({required this.child});

  /// 8dp x0.5
  factory Space.xs() => const Space._(child: SizedBox(width: _space * .5, height: _space * .5));

  /// 8dp x1
  factory Space.sm() => const Space._(child: SizedBox(width: _space, height: _space));

  /// 8dp x2
  factory Space.md() => const Space._(child: SizedBox(width: _space * 2, height: _space * 2));

  /// 8dp x3
  factory Space.lg() => const Space._(child: SizedBox(width: _space * 3, height: _space * 3));

  /// 8dp x4
  factory Space.xl() => const Space._(child: SizedBox(width: _space * 4, height: _space * 4));

  /// 8dp x8
  factory Space.xxl() => const Space._(child: SizedBox(width: _space * 8, height: _space * 8));

  /// 8dp x12
  factory Space.xxxl() => const Space._(child: SizedBox(width: _space * 12, height: _space * 12));

  /// {@macro space}
  final Widget child;

  @override
  Widget build(BuildContext context) => child;
}
