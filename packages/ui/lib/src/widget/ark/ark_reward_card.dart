import 'package:flutter/material.dart';
import 'package:ui/src/widget/ark/ark_palette.dart';

/// Height of [ArkRewardCard] including its label.
const arkRewardCardHeight = 108.0;

/// Width of [ArkRewardCard] in a horizontal list.
const arkRewardCardWidth = 264.0;

/// Status of a reward.
enum ArkRewardStatus {
  /// Goal is not reached yet but can be.
  active,

  /// Goal is reached.
  completed,

  /// Goal cannot be reached with the current tasks.
  unreachable,
}

/// {@template ark_reward_card}
/// Reward card with a "reward set" label above it.
/// {@endtemplate}
class ArkRewardCard extends StatelessWidget {
  /// {@macro ark_reward_card}
  const ArkRewardCard({
    required this.label,
    required this.title,
    required this.goal,
    required this.progress,
    required this.status,
    this.description,
    this.menu,
    super.key,
  });

  /// Small label above the card.
  final String label;

  /// Reward title.
  final String title;

  /// Reward description.
  final String? description;

  /// Goal weight.
  final int goal;

  /// Current completed weight.
  final int progress;

  /// Reward status.
  final ArkRewardStatus status;

  /// Trailing menu button.
  final Widget? menu;

  @override
  Widget build(BuildContext context) {
    final palette = ArkPalette.from(context);
    final isActive = status == ArkRewardStatus.active;
    final foreground = isActive ? palette.onEmphasis : palette.text;
    final description = this.description;
    return SizedBox(
      height: arkRewardCardHeight,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Text(
                label,
                style: TextStyle(color: palette.textMuted, fontSize: 11, letterSpacing: 1.5),
              ),
              const SizedBox(width: 4),
              Icon(Icons.arrow_drop_down, size: 16, color: palette.accent),
            ],
          ),
          const SizedBox(height: 2),
          Expanded(
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: isActive ? palette.emphasis : palette.disabled,
                boxShadow: isActive
                    ? const [BoxShadow(color: Color(0x40000000), blurRadius: 4, offset: Offset(0, 2))]
                    : null,
              ),
              child: Stack(
                children: [
                  if (status == ArkRewardStatus.unreachable)
                    Positioned.fill(child: CustomPaint(painter: _HatchPainter(palette.danger.withValues(alpha: .25)))),
                  Row(
                    children: [
                      Expanded(
                        child: Opacity(
                          opacity: status == ArkRewardStatus.completed ? .45 : 1,
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(10, 8, 0, 8),
                            child: Row(
                              children: [
                                _GoalBadge(goal: goal, isActive: isActive),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        title,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          color: foreground,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      if (description != null && description.isNotEmpty)
                                        Text(
                                          description,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(color: foreground.withValues(alpha: .7), fontSize: 12),
                                        ),
                                      const SizedBox(height: 2),
                                      Text(
                                        '${progress.clamp(0, goal)} / $goal',
                                        style: TextStyle(
                                          color: isActive ? palette.accent : foreground,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w700,
                                          letterSpacing: 1,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      if (menu != null)
                        IconTheme(
                          data: IconThemeData(color: foreground),
                          child: menu!,
                        ),
                    ],
                  ),
                  if (status != ArkRewardStatus.active)
                    Positioned(
                      left: 74,
                      top: 0,
                      bottom: 0,
                      child: Center(
                        child: _Stamp(
                          text: status == ArkRewardStatus.completed ? 'Completed' : 'Unreachable',
                          color: status == ArkRewardStatus.completed ? palette.emphasis : palette.danger,
                          textColor: palette.onEmphasis,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _GoalBadge extends StatelessWidget {
  const _GoalBadge({required this.goal, required this.isActive});

  final int goal;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    final palette = ArkPalette.from(context);
    return Container(
      width: 52,
      height: 52,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isActive ? palette.card : palette.cardBorder,
        border: Border.all(color: isActive ? palette.accent : palette.textMuted, width: 3),
      ),
      alignment: Alignment.center,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '$goal',
            style: TextStyle(color: palette.text, fontSize: 18, fontWeight: FontWeight.w700, height: 1),
          ),
          Text(
            'WT',
            style: TextStyle(color: palette.textMuted, fontSize: 9, letterSpacing: 1, height: 1.2),
          ),
        ],
      ),
    );
  }
}

class _Stamp extends StatelessWidget {
  const _Stamp({required this.text, required this.color, required this.textColor});

  final String text;
  final Color color;
  final Color textColor;

  @override
  Widget build(BuildContext context) => DecoratedBox(
    decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(3)),
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      child: Text(
        text,
        style: TextStyle(color: textColor, fontSize: 18, fontWeight: FontWeight.w500),
      ),
    ),
  );
}

class _HatchPainter extends CustomPainter {
  const _HatchPainter(this.color);

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 6;
    canvas.clipRect(Offset.zero & size);
    for (var x = -size.height; x < size.width; x += 16) {
      canvas.drawLine(Offset(x, size.height), Offset(x + size.height, 0), paint);
    }
  }

  @override
  bool shouldRepaint(covariant _HatchPainter oldDelegate) => oldDelegate.color != color;
}
