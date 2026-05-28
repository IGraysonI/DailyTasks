import 'package:flutter/material.dart';
import 'package:ui/src/widget/base/scaffold_padding.dart';

/// {@template group_separator}
/// GroupSeparator widget for separating groups of items in a list.
/// {@endtemplate}
class GroupSeparator extends StatelessWidget {
  /// {@macro group_separator}
  const GroupSeparator({
    required this.title,
    super.key, // ignore: unused_element
  });
  final String title;

  @override
  Widget build(BuildContext context) => SliverPadding(
    padding: ScaffoldPadding.of(context),
    sliver: SliverToBoxAdapter(
      child: SizedBox(
        height: 48,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            const SizedBox(width: 48, child: Divider(indent: 16, endIndent: 16)),
            Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(height: 1),
            ),
            const Expanded(child: Divider(indent: 16, endIndent: 16)),
          ],
        ),
      ),
    ),
  );
}
