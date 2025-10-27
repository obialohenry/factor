import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class TokenAvatar extends StatelessWidget {
  const TokenAvatar({
    super.key,
    this.imageUrl,
    this.symbol,
    this.size = 36,
    this.borderRadius,
  });

  final String? imageUrl;
  final String? symbol;
  final double size;
  final double? borderRadius;

  @override
  Widget build(BuildContext context) {
    final effectiveRadius = borderRadius ?? size / 2;
    final placeholder = _AvatarPlaceholder(
      symbol: symbol,
      size: size,
      borderRadius: effectiveRadius,
    );

    if (imageUrl == null || imageUrl!.isEmpty) {
      return placeholder;
    }

    final devicePixelRatio =
        MediaQuery.maybeOf(context)?.devicePixelRatio ?? 2.0;
    final cacheWidth = (size * devicePixelRatio).round();
    final cacheHeight = (size * devicePixelRatio).round();

    return ClipRRect(
      borderRadius: BorderRadius.circular(effectiveRadius),
      child: CachedNetworkImage(
        imageUrl: imageUrl!,
        width: size,
        height: size,
        fit: BoxFit.cover,
        memCacheWidth: cacheWidth > 0 ? cacheWidth : null,
        memCacheHeight: cacheHeight > 0 ? cacheHeight : null,
        placeholder: (_, __) => placeholder,
        errorWidget: (_, __, ___) => placeholder,
        fadeInDuration: const Duration(milliseconds: 180),
        fadeOutDuration: const Duration(milliseconds: 120),
      ),
    );
  }
}

class _AvatarPlaceholder extends StatelessWidget {
  const _AvatarPlaceholder({
    required this.symbol,
    required this.size,
    required this.borderRadius,
  });

  final String? symbol;
  final double size;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final background = theme.colorScheme.primary.withValues(alpha: 0.18);
    final foreground = theme.colorScheme.primary;

    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: Text(
        _initials(symbol),
        style: theme.textTheme.labelLarge?.copyWith(
          fontWeight: FontWeight.w700,
          color: foreground,
        ),
      ),
    );
  }

  String _initials(String? value) {
    if (value == null) return '?';
    final trimmed = value.trim();
    if (trimmed.isEmpty) return '?';
    final runes = trimmed.runes.toList();
    final count = runes.length >= 2 ? 2 : runes.length;
    return String.fromCharCodes(runes.take(count)).toUpperCase();
  }
}
