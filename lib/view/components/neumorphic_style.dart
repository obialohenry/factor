import 'package:flutter/material.dart';

/// Shared helpers for composing the neumorphic look & feel used throughout the
/// experience. Centralising the styling keeps light and dark themes in sync.
class NeumorphicStyle {
  const NeumorphicStyle._();

  static const double _defaultSpread = 0;

  static Color backgroundColor(BuildContext context) {
    final theme = Theme.of(context);
    if (theme.brightness == Brightness.dark) {
      return const Color(0xFF131723);
    }
    return const Color(0xFFE9EDF6);
  }

  static BoxDecoration outerDecoration(
    BuildContext context, {
    double borderRadius = 24,
    Color? background,
    bool isPressed = false,
    bool isActive = false,
    bool isAccent = false,
    Gradient? gradient,
  }) {
    final theme = Theme.of(context);
    final base = background ?? backgroundColor(context);
    final highlight = _highlightColor(theme);
    final shadow = shadowColor(theme);
    final offsetValue = isPressed ? 1.0 : 3.0;
    final spread = isPressed ? _defaultSpread * 0.5 : _defaultSpread;

    return BoxDecoration(
      color: gradient == null ? base : null,
      gradient:
          gradient ??
          (isAccent ? _accentGradient(theme.colorScheme.primary) : null),
      borderRadius: BorderRadius.circular(borderRadius),
      boxShadow: [
        BoxShadow(
          color: highlight,
          offset: Offset(-offsetValue, -offsetValue),
          spreadRadius: spread,
        ),
        BoxShadow(
          color: shadow,
          offset: Offset(offsetValue, offsetValue),
          spreadRadius: spread,
        ),
      ],
      border: isActive
          ? Border.all(
              width: 2.6,
              color: theme.colorScheme.primary.withValues(
                alpha: theme.brightness == Brightness.dark ? 0.7 : 0.5,
              ),
            )
          : null,
    );
  }

  static BoxDecoration sheetDecoration(BuildContext context) {
    final theme = Theme.of(context);
    return BoxDecoration(
      color: backgroundColor(context),
      borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
      boxShadow: [
        BoxShadow(
          color: shadowColor(
            theme,
          ).withValues(alpha: theme.brightness == Brightness.dark ? 0.5 : 0.25),
          offset: const Offset(0, -8),
          blurRadius: 32,
        ),
      ],
    );
  }

  static Gradient _accentGradient(Color color) {
    final hsl = HSLColor.fromColor(color);
    final lighter = hsl
        .withLightness((hsl.lightness + 0.12).clamp(0.0, 1.0))
        .toColor();
    final darker = hsl
        .withLightness((hsl.lightness - 0.12).clamp(0.0, 1.0))
        .toColor();
    return LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [lighter, darker],
    );
  }

  static Color _highlightColor(ThemeData theme) {
    if (theme.brightness == Brightness.dark) {
      return Colors.white.withValues(alpha: 0.09);
    }
    return Colors.white.withValues(alpha: 0.9);
  }

  static Color shadowColor(ThemeData theme) {
    if (theme.brightness == Brightness.dark) {
      return Colors.black.withValues(alpha: 0.55);
    }
    return const Color(0xFF94A3B8).withValues(alpha: 0.5);
  }

  /// Formats a numeric value into a digit string suitable for manual editing.
  static String formatDigits(double value) {
    final isLarge = value.abs() >= 1;
    final decimals = isLarge ? 2 : 6;
    final formatted = value.toStringAsFixed(decimals);
    return _trimTrailingZeros(formatted);
  }

  static String _trimTrailingZeros(String value) {
    if (!value.contains('.')) return value;
    return value
        .replaceFirst(RegExp(r'0+$'), '')
        .replaceFirst(RegExp(r'\.$'), '');
  }
}
