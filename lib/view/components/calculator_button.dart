import 'package:factor/view/components/neumorphic_button.dart';
import 'package:flutter/material.dart';

class CalculatorButton extends StatelessWidget {
  const CalculatorButton({
    super.key,
    required this.label,
    required this.onTap,
    this.isAccent = false,
  });

  final String label;
  final VoidCallback onTap;
  final bool isAccent;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final foreground = isAccent ? Colors.white : theme.colorScheme.onSurface;

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth.isFinite
            ? constraints.maxWidth
            : 72.0;
        final height = constraints.maxHeight.isFinite
            ? constraints.maxHeight
            : 72.0;

        return NeumorphicButton(
          onPressed: onTap,
          width: width,
          height: height,
          borderRadius: 28,
          isAccent: isAccent,
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              label,
              style: theme.textTheme.titleLarge?.copyWith(
                color: foreground,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        );
      },
    );
  }
}
