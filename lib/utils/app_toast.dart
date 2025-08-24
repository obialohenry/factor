import 'package:bot_toast/bot_toast.dart';
import 'package:factor/cofig/factor_colors.dart';
import 'package:factor/src/components.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// Displays a temporary toast notification at the bottom center of the screen.
void showToast({required String msg}) {
  Duration toastDuration = const Duration(seconds: 3);

  BotToast.showCustomNotification(
    toastBuilder: (cancelFunc) {
      return Container(
        margin: EdgeInsets.only(bottom: 80),
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: FactorColorsDark.kSlateGray,
          borderRadius: BorderRadius.circular(8),
        ),
        child: TextView(text: msg, color: FactorColorsDark.kWhite, fontWeight: FontWeight.w700),
      );
    },
    align: Alignment.bottomCenter,
    duration: toastDuration,
    animationDuration: const Duration(milliseconds: 300),
    animationReverseDuration: const Duration(milliseconds: 200),
  );
}
