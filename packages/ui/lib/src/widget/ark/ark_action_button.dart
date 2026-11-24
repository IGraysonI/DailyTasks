import 'package:flutter/material.dart';
import 'package:ui/src/widget/ark/ark_palette.dart';

/// Visual tone of an [ArkActionButton].
enum ArkTone {
  /// Filled with the accent color.
  primary,

  /// Filled with the emphasis color.
  neutral,

  /// Outlined with the danger color.
  danger,
}

/// Angular shape with the top-right corner cut off.
const arkCutShape = BeveledRectangleBorder(borderRadius: BorderRadius.only(topRight: Radius.circular(8)));

/// {@template ark_action}
/// Description of a single toolbar action.
/// {@endtemplate}
@immutable
class ArkAction {
  /// {@macro ark_action}
  const ArkAction({
    required this.icon,
    required this.label,
    required this.onPressed,
    this.tone = ArkTone.neutral,
  });

  /// Action icon.
  final IconData icon;

  /// Action label, also used as a tooltip.
  final String label;

  /// Action callback.
  final VoidCallback? onPressed;

  /// Visual tone.
  final ArkTone tone;
}

/// {@template ark_action_button}
/// Compact angular button. Shows only the icon when [showLabel] is false.
/// {@endtemplate}
class ArkActionButton extends StatelessWidget {
  /// {@macro ark_action_button}
  const ArkActionButton({
    required this.action,
    this.showLabel = true,
    super.key,
  });

  /// Action to render.
  final ArkAction action;

  /// Whether the label is rendered next to the icon.
  final bool showLabel;

  @override
  Widget build(BuildContext context) {
    final palette = ArkPalette.from(context);
    final (background, foreground, border) = switch (action.tone) {
      ArkTone.primary => (palette.accent, Colors.white, BorderSide.none),
      ArkTone.neutral => (palette.emphasis, palette.onEmphasis, BorderSide.none),
      ArkTone.danger => (Colors.transparent, palette.danger, BorderSide(color: palette.danger, width: 1.5)),
    };
    return Tooltip(
      message: action.label,
      child: Material(
        color: background,
        shape: arkCutShape.copyWith(side: border),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: action.onPressed,
          child: SizedBox(
            height: 36,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: showLabel ? 12 : 9),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(action.icon, size: 18, color: foreground),
                  if (showLabel) ...[
                    const SizedBox(width: 6),
                    Text(
                      action.label.toUpperCase(),
                      style: TextStyle(
                        color: foreground,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// {@template ark_toolbar}
/// Row of [ArkActionButton]s with an optional [leading] widget.
/// Switches to icon-only buttons when the available width is below [compactWidth].
/// {@endtemplate}
class ArkToolbar extends StatelessWidget {
  /// {@macro ark_toolbar}
  const ArkToolbar({
    required this.actions,
    this.leading,
    this.compactWidth = 560,
    this.forceCompact = false,
    super.key,
  });

  /// Actions to render.
  final List<ArkAction> actions;

  /// Widget placed before the actions, expanded to fill the free space.
  final Widget? leading;

  /// Width below which labels are hidden.
  final double compactWidth;

  /// Hide labels regardless of the available width.
  final bool forceCompact;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) {
      final showLabel = !forceCompact && constraints.maxWidth >= compactWidth;
      return Row(
        children: [
          Expanded(child: leading ?? const SizedBox.shrink()),
          for (final action in actions) ...[
            const SizedBox(width: 6),
            ArkActionButton(action: action, showLabel: showLabel),
          ],
        ],
      );
    },
  );
}
