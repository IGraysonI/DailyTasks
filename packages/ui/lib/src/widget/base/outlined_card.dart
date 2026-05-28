import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ui/src/const/values.dart';

class OutlinedCard extends StatelessWidget {
  const OutlinedCard({required this.child, this.margin, this.padding, this.onCardTap, super.key});

  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final VoidCallback? onCardTap;

  @override
  Widget build(BuildContext context) => Card(
    elevation: 0,
    margin: margin,
    shape: RoundedRectangleBorder(
      side: BorderSide(color: Theme.of(context).colorScheme.outline),
      borderRadius: const BorderRadius.all(Radius.circular(12)),
    ),
    child: ClipRRect(
      borderRadius: BorderRadius.circular(Values.cornerRadius),
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          onTap: () {
            HapticFeedback.lightImpact();
            onCardTap?.call();
          },
          child: padding != null ? Padding(padding: padding!, child: child) : child,
        ),
      ),
    ),
  );
}
