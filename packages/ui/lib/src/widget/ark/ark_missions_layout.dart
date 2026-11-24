import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:ui/src/widget/ark/ark_palette.dart';

/// Height of the rewards strip in portrait layout.
const arkRewardsStripHeight = 184.0;

/// {@template ark_missions_layout}
/// Adaptive layout of a missions page.
///
/// Landscape (width >= height): rewards panel on the left, tasks on the right, both scroll vertically.
/// Portrait: rewards strip on top scrolling horizontally, tasks below scrolling vertically.
/// The decision is based on the available constraints, so resizing a desktop window switches layouts too.
/// {@endtemplate}
class ArkMissionsLayout extends StatelessWidget {
  /// {@macro ark_missions_layout}
  const ArkMissionsLayout({
    required this.rewardsBuilder,
    required this.tasks,
    super.key,
  });

  /// Builds the rewards panel for the given scroll [Axis].
  final Widget Function(BuildContext context, Axis axis) rewardsBuilder;

  /// Tasks section.
  final Widget tasks;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) {
      final isLandscape = constraints.maxWidth >= constraints.maxHeight;
      // Mouse drag is enabled so the horizontal strip is usable on desktop without a touchpad.
      final rewards = ScrollConfiguration(
        behavior: ScrollConfiguration.of(context).copyWith(dragDevices: PointerDeviceKind.values.toSet()),
        child: rewardsBuilder(context, isLandscape ? Axis.vertical : Axis.horizontal),
      );
      if (isLandscape) {
        return Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(width: (constraints.maxWidth * .3).clamp(280.0, 440.0), child: rewards),
            const SizedBox(width: 16),
            Expanded(child: tasks),
          ],
        );
      }
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(height: arkRewardsStripHeight, child: rewards),
          const SizedBox(height: 12),
          Expanded(child: tasks),
        ],
      );
    },
  );
}

/// {@template ark_panel}
/// Flat panel with a [header] and an expanded [child].
/// {@endtemplate}
class ArkPanel extends StatelessWidget {
  /// {@macro ark_panel}
  const ArkPanel({
    required this.header,
    required this.child,
    super.key,
  });

  /// Panel header.
  final Widget header;

  /// Panel content.
  final Widget child;

  @override
  Widget build(BuildContext context) => ColoredBox(
    color: ArkPalette.from(context).panel,
    child: Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          header,
          const SizedBox(height: 8),
          Expanded(child: child),
        ],
      ),
    ),
  );
}

/// {@template ark_empty_state}
/// Compact placeholder for an empty list.
/// {@endtemplate}
class ArkEmptyState extends StatelessWidget {
  /// {@macro ark_empty_state}
  const ArkEmptyState({required this.text, super.key});

  /// Placeholder text.
  final String text;

  @override
  Widget build(BuildContext context) {
    final palette = ArkPalette.from(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Text(
          text.toUpperCase(),
          textAlign: TextAlign.center,
          style: TextStyle(color: palette.textMuted, fontSize: 13, letterSpacing: 2, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}
