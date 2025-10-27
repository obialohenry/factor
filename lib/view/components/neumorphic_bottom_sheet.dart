import 'package:factor/view/components/neumorphic_style.dart';
import 'package:flutter/material.dart';

Future<T?> showNeumorphicModalSheet<T>({
  required BuildContext context,
  required WidgetBuilder builder,
  double heightFactor = 0.85,
  bool isScrollControlled = true,
}) {
  final theme = Theme.of(context);

  return showModalBottomSheet<T>(
    context: context,
    isScrollControlled: isScrollControlled,
    backgroundColor: NeumorphicStyle.backgroundColor(context),
    barrierColor: theme.colorScheme.onSurface.withValues(alpha: 0.35),
    builder: (sheetContext) {
      return AnimatedPadding(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(sheetContext).viewInsets.bottom,
        ),
        child: FractionallySizedBox(
          heightFactor: heightFactor,
          alignment: Alignment.bottomCenter,
          child: DecoratedBox(
            decoration: NeumorphicStyle.sheetDecoration(sheetContext),
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(32),
              ),
              child: builder(sheetContext),
            ),
          ),
        ),
      );
    },
  );
}

class NeumorphicSheetHandle extends StatelessWidget {
  const NeumorphicSheetHandle({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 12, bottom: 16),
      child: Center(
        child: Container(
          width: 56,
          height: 6,
          decoration: BoxDecoration(
            color: Theme.of(
              context,
            ).colorScheme.onSurface.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(999),
          ),
        ),
      ),
    );
  }
}
