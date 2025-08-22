import 'package:flutter/material.dart';

class Gap extends StatelessWidget {
  ///Creates a space of whatever size property you pass in.
  const Gap(this.size, {super.key});

  final double? size;

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: size ?? 10,
    );
  }
}