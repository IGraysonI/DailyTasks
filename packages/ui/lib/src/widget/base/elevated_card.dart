import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// {@template elevated_card}
/// A card with an elevation that can be tapped.
/// {@endtemplate}
class ElevatedCard extends StatelessWidget {
  /// {@macro elevated_card}
  const ElevatedCard({
    required this.child,
    this.padding,
    this.margin,
    this.onCardTap,
    super.key,
  });

  /// The widget inside the card.
  final Widget child;

  /// The padding of the card.
  final EdgeInsetsGeometry? padding;

  /// The margin of the card.
  final EdgeInsetsGeometry? margin;

  /// The callback that is called when the card is tapped.
  final VoidCallback? onCardTap;

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: () {
      HapticFeedback.lightImpact();
      onCardTap?.call();
    },
    child: Card(
      margin: margin ?? EdgeInsets.zero,
      child: padding != null ? Padding(padding: padding!, child: child) : child,
    ),
  );
}
