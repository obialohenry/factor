import 'package:factor/view/components/neumorphic_style.dart';
import 'package:flutter/material.dart';

class NeumorphicButton extends StatefulWidget {
  const NeumorphicButton({
    super.key,
    required this.child,
    this.onPressed,
    this.width,
    this.height,
    this.borderRadius = 24,
    this.padding,
    this.isAccent = false,
    this.isSelected = false,
  });

  final Widget child;
  final VoidCallback? onPressed;
  final double? width;
  final double? height;
  final double borderRadius;
  final EdgeInsetsGeometry? padding;
  final bool isAccent;
  final bool isSelected;

  @override
  State<NeumorphicButton> createState() => _NeumorphicButtonState();
}

class _NeumorphicButtonState extends State<NeumorphicButton> {
  bool _isPressed = false;

  void _handleTapDown(TapDownDetails details) {
    if (widget.onPressed == null) return;
    setState(() => _isPressed = true);
  }

  void _handleTapUp(TapUpDetails details) {
    if (widget.onPressed == null) return;
    setState(() => _isPressed = false);
  }

  void _handleTapCancel() {
    if (widget.onPressed == null) return;
    setState(() => _isPressed = false);
  }

  @override
  Widget build(BuildContext context) {
    final isEnabled = widget.onPressed != null;
    final decoration = NeumorphicStyle.outerDecoration(
      context,
      borderRadius: widget.borderRadius,
      isPressed: _isPressed && isEnabled,
      isAccent: widget.isAccent,
      isActive: widget.isSelected,
    );

    final child = AnimatedContainer(
      duration: const Duration(milliseconds: 160),
      curve: Curves.easeOut,
      width: widget.width,
      height: widget.height,
      padding:
          widget.padding ??
          EdgeInsets.symmetric(
            horizontal: widget.width == null ? 24 : 0,
            vertical: widget.height == null ? 18 : 0,
          ),
      decoration: decoration,
      child: Center(child: widget.child),
    );

    if (!isEnabled) {
      return child;
    }

    return Semantics(
      button: true,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTapDown: _handleTapDown,
        onTapCancel: _handleTapCancel,
        onTapUp: (details) {
          _handleTapUp(details);
          widget.onPressed?.call();
        },
        child: child,
      ),
    );
  }
}
