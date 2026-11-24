import 'package:flutter/material.dart';
import 'package:ui/src/widget/ark/ark_action_button.dart';
import 'package:ui/src/widget/ark/ark_palette.dart';

/// {@template ark_task_card}
/// Task card: tag, title, description and a large completion button on the right.
/// {@endtemplate}
class ArkTaskCard extends StatelessWidget {
  /// {@macro ark_task_card}
  const ArkTaskCard({
    required this.tag,
    required this.title,
    required this.isCompleted,
    required this.onToggle,
    this.description,
    this.menu,
    this.completeLabel = 'Complete',
    this.completedLabel = 'Completed',
    super.key,
  });

  /// Small dark tag before the title.
  final String tag;

  /// Task title.
  final String title;

  /// Task description.
  final String? description;

  /// Whether the task is completed.
  final bool isCompleted;

  /// Completion toggle callback.
  final VoidCallback onToggle;

  /// Trailing menu button.
  final Widget? menu;

  /// Button label for an open task.
  final String completeLabel;

  /// Button label for a completed task.
  final String completedLabel;

  @override
  Widget build(BuildContext context) {
    final palette = ArkPalette.from(context);
    final description = this.description;
    return LayoutBuilder(
      builder: (context, constraints) {
        final isNarrow = constraints.maxWidth < 520;
        return Container(
          constraints: const BoxConstraints(minHeight: 96),
          decoration: BoxDecoration(
            color: palette.card,
            border: Border.all(color: palette.cardBorder),
          ),
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(width: 4, color: isCompleted ? palette.disabled : palette.accent),
                Expanded(
                  child: Opacity(
                    opacity: isCompleted ? .55 : 1,
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(isNarrow ? 12 : 20, 10, 8, 10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _Tag(tag),
                          const SizedBox(height: 4),
                          Text(
                            title,
                            style: TextStyle(
                              color: palette.text,
                              fontSize: isNarrow ? 16 : 20,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          if (description != null && description.isNotEmpty)
                            Text(
                              description,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(color: palette.textMuted, fontSize: 13),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
                Center(
                  child: _CompleteButton(
                    label: isCompleted ? completedLabel : completeLabel,
                    isCompleted: isCompleted,
                    width: isNarrow ? 112 : 220,
                    height: isNarrow ? 52 : 76,
                    onPressed: onToggle,
                  ),
                ),
                if (menu != null)
                  Center(
                    child: IconTheme(
                      data: IconThemeData(color: palette.text),
                      child: menu!,
                    ),
                  ),
                if (menu == null) const SizedBox(width: 8),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _Tag extends StatelessWidget {
  const _Tag(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    final palette = ArkPalette.from(context);
    return DecoratedBox(
      decoration: BoxDecoration(color: palette.emphasis, borderRadius: BorderRadius.circular(4)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
        child: Text(text, style: TextStyle(color: palette.onEmphasis, fontSize: 11, letterSpacing: .5)),
      ),
    );
  }
}

class _CompleteButton extends StatelessWidget {
  const _CompleteButton({
    required this.label,
    required this.isCompleted,
    required this.width,
    required this.height,
    required this.onPressed,
  });

  final String label;
  final bool isCompleted;
  final double width;
  final double height;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final palette = ArkPalette.from(context);
    return SizedBox(
      width: width,
      height: height,
      child: Material(
        color: isCompleted ? palette.disabled : palette.accent,
        shape: arkCutShape,
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onPressed,
          child: Center(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Text(
                  label,
                  style: TextStyle(
                    color: isCompleted ? palette.onDisabled : Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
