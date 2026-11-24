import 'package:flutter/material.dart';
import 'package:ui/src/widget/ark/ark_palette.dart';

/// Height of the top navigation row: nav block and tab bar.
const arkTopBarHeight = 56.0;

/// {@template ark_nav_block}
/// Dark block of square navigation slots separated by thin dividers.
/// {@endtemplate}
class ArkNavBlock extends StatelessWidget {
  /// {@macro ark_nav_block}
  const ArkNavBlock({required this.children, super.key});

  /// Slots, usually [ArkNavSlot]s.
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final palette = ArkPalette.from(context);
    return DecoratedBox(
      decoration: BoxDecoration(
        color: palette.emphasis,
        boxShadow: const [BoxShadow(color: Color(0x40000000), blurRadius: 6, offset: Offset(0, 3))],
      ),
      child: SizedBox(
        height: arkTopBarHeight,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (var i = 0; i < children.length; i++) ...[
              if (i > 0) VerticalDivider(width: 1, thickness: 1, color: palette.onEmphasis.withValues(alpha: .15)),
              children[i],
            ],
          ],
        ),
      ),
    );
  }
}

/// {@template ark_nav_slot}
/// Square slot inside [ArkNavBlock]. Renders an empty inactive slot when [icon] is null.
/// {@endtemplate}
class ArkNavSlot extends StatelessWidget {
  /// {@macro ark_nav_slot}
  const ArkNavSlot({
    this.icon,
    this.tooltip,
    this.onPressed,
    super.key,
  });

  /// Slot icon.
  final IconData? icon;

  /// Slot tooltip.
  final String? tooltip;

  /// Slot callback.
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final palette = ArkPalette.from(context);
    final icon = this.icon;
    final slot = SizedBox.square(
      dimension: arkTopBarHeight,
      child: icon == null ? null : Icon(icon, color: palette.onEmphasis, size: 26),
    );
    if (icon == null) return slot;
    return Tooltip(
      message: tooltip ?? '',
      child: InkWell(onTap: onPressed, child: slot),
    );
  }
}

/// {@template ark_tab_item}
/// Description of a tab in [ArkTabBar].
/// {@endtemplate}
@immutable
class ArkTabItem {
  /// {@macro ark_tab_item}
  const ArkTabItem({required this.label, required this.icon});

  /// Tab label.
  final String label;

  /// Tab icon.
  final IconData icon;
}

/// {@template ark_tab_bar}
/// Tab bar where the active tab is dark with an accent underline and a pointer triangle.
/// {@endtemplate}
class ArkTabBar extends StatelessWidget {
  /// {@macro ark_tab_bar}
  const ArkTabBar({
    required this.controller,
    required this.items,
    super.key,
  }) : assert(items.length > 0, 'items cannot be empty');

  /// Controller shared with the corresponding [TabBarView].
  final TabController controller;

  /// Tabs to render.
  final List<ArkTabItem> items;

  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: controller,
    builder: (context, _) => SizedBox(
      height: arkTopBarHeight,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (var i = 0; i < items.length; i++)
            Expanded(
              child: _ArkTab(
                item: items[i],
                isActive: controller.index == i,
                onTap: () => controller.animateTo(i),
              ),
            ),
        ],
      ),
    ),
  );
}

class _ArkTab extends StatelessWidget {
  const _ArkTab({
    required this.item,
    required this.isActive,
    required this.onTap,
  });

  final ArkTabItem item;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final palette = ArkPalette.from(context);
    final foreground = isActive ? palette.onEmphasis : palette.text;
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Positioned.fill(
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            decoration: BoxDecoration(
              color: isActive ? palette.emphasis : palette.card,
              border: Border(
                bottom: BorderSide(color: isActive ? palette.accent : palette.cardBorder, width: 3),
                right: BorderSide(color: palette.cardBorder),
              ),
              boxShadow: isActive
                  ? const [BoxShadow(color: Color(0x40000000), blurRadius: 6, offset: Offset(0, 3))]
                  : null,
            ),
            child: InkWell(
              onTap: onTap,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Center(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(item.icon, color: foreground, size: 26),
                        const SizedBox(width: 10),
                        Text(
                          item.label,
                          style: TextStyle(color: foreground, fontSize: 20, fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        if (isActive)
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Center(
              child: CustomPaint(size: const Size(14, 8), painter: _TrianglePainter(palette.accent)),
            ),
          ),
      ],
    );
  }
}

class _TrianglePainter extends CustomPainter {
  const _TrianglePainter(this.color);

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final path = Path()
      ..moveTo(0, size.height)
      ..lineTo(size.width / 2, 0)
      ..lineTo(size.width, size.height)
      ..close();
    canvas.drawPath(path, Paint()..color = color);
  }

  @override
  bool shouldRepaint(covariant _TrianglePainter oldDelegate) => oldDelegate.color != color;
}
