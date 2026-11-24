import 'package:flutter/material.dart';

/// {@template ark_palette}
/// Color palette of the Arknights-styled UI. Registered as a [ThemeExtension].
/// {@endtemplate}
@immutable
class ArkPalette extends ThemeExtension<ArkPalette> {
  /// {@macro ark_palette}
  const ArkPalette({
    required this.background,
    required this.panel,
    required this.card,
    required this.cardBorder,
    required this.emphasis,
    required this.onEmphasis,
    required this.text,
    required this.textMuted,
    required this.accent,
    required this.highlight,
    required this.danger,
    required this.disabled,
    required this.onDisabled,
  });

  /// Light variant.
  static const light = ArkPalette(
    background: Color(0xFFE8E8E8),
    panel: Color(0xFFD9D9D9),
    card: Color(0xFFDEDEDE),
    cardBorder: Color(0xFFC9C9C9),
    emphasis: Color(0xFF2E2E2E),
    onEmphasis: Color(0xFFF4F4F4),
    text: Color(0xFF262626),
    textMuted: Color(0xFF7D7D7D),
    accent: Color(0xFF0098DC),
    highlight: Color(0xFFFFD802),
    danger: Color(0xFFE0393E),
    disabled: Color(0xFFBDBDBD),
    onDisabled: Color(0xFFFFFFFF),
  );

  /// Dark variant.
  static const dark = ArkPalette(
    background: Color(0xFF151515),
    panel: Color(0xFF1F1F1F),
    card: Color(0xFF262626),
    cardBorder: Color(0xFF363636),
    emphasis: Color(0xFF3B3B3B),
    onEmphasis: Color(0xFFF4F4F4),
    text: Color(0xFFE6E6E6),
    textMuted: Color(0xFF8E8E8E),
    accent: Color(0xFF23ADE5),
    highlight: Color(0xFFFFD802),
    danger: Color(0xFFFF5A5F),
    disabled: Color(0xFF4A4A4A),
    onDisabled: Color(0xFFBDBDBD),
  );

  /// Palette for the given [brightness].
  static ArkPalette of(Brightness brightness) => brightness == Brightness.dark ? dark : light;

  /// Palette of the current theme. Falls back to the variant matching the theme brightness.
  static ArkPalette from(BuildContext context) {
    final theme = Theme.of(context);
    return theme.extension<ArkPalette>() ?? of(theme.brightness);
  }

  /// Screen background.
  final Color background;

  /// Background of side panels.
  final Color panel;

  /// Background of regular cards.
  final Color card;

  /// Border of regular cards.
  final Color cardBorder;

  /// Dark emphasized surfaces: active tab, active reward, tags.
  final Color emphasis;

  /// Content on top of [emphasis].
  final Color onEmphasis;

  /// Primary text.
  final Color text;

  /// Secondary text.
  final Color textMuted;

  /// Accent color for primary actions and indicators.
  final Color accent;

  /// Secondary accent for markers.
  final Color highlight;

  /// Destructive actions and warnings.
  final Color danger;

  /// Background of inactive elements.
  final Color disabled;

  /// Content on top of [disabled].
  final Color onDisabled;

  @override
  ArkPalette copyWith({
    Color? background,
    Color? panel,
    Color? card,
    Color? cardBorder,
    Color? emphasis,
    Color? onEmphasis,
    Color? text,
    Color? textMuted,
    Color? accent,
    Color? highlight,
    Color? danger,
    Color? disabled,
    Color? onDisabled,
  }) => ArkPalette(
    background: background ?? this.background,
    panel: panel ?? this.panel,
    card: card ?? this.card,
    cardBorder: cardBorder ?? this.cardBorder,
    emphasis: emphasis ?? this.emphasis,
    onEmphasis: onEmphasis ?? this.onEmphasis,
    text: text ?? this.text,
    textMuted: textMuted ?? this.textMuted,
    accent: accent ?? this.accent,
    highlight: highlight ?? this.highlight,
    danger: danger ?? this.danger,
    disabled: disabled ?? this.disabled,
    onDisabled: onDisabled ?? this.onDisabled,
  );

  @override
  ArkPalette lerp(ArkPalette? other, double t) {
    if (other == null) return this;
    return ArkPalette(
      background: Color.lerp(background, other.background, t)!,
      panel: Color.lerp(panel, other.panel, t)!,
      card: Color.lerp(card, other.card, t)!,
      cardBorder: Color.lerp(cardBorder, other.cardBorder, t)!,
      emphasis: Color.lerp(emphasis, other.emphasis, t)!,
      onEmphasis: Color.lerp(onEmphasis, other.onEmphasis, t)!,
      text: Color.lerp(text, other.text, t)!,
      textMuted: Color.lerp(textMuted, other.textMuted, t)!,
      accent: Color.lerp(accent, other.accent, t)!,
      highlight: Color.lerp(highlight, other.highlight, t)!,
      danger: Color.lerp(danger, other.danger, t)!,
      disabled: Color.lerp(disabled, other.disabled, t)!,
      onDisabled: Color.lerp(onDisabled, other.onDisabled, t)!,
    );
  }
}
