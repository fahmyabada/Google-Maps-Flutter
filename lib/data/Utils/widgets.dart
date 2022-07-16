import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';

void showToastt({
  required String text,
  required ToastStates state,
  required BuildContext context,
}) =>
    showToast(
      text,
      context: context,
      backgroundColor: chooseToastColor(state),
      animation: StyledToastAnimation.scale,
      reverseAnimation: StyledToastAnimation.fade,
      position: StyledToastPosition.bottom,
      animDuration: const Duration(seconds: 1),
      duration: const Duration(seconds: 3),
      curve: Curves.elasticOut,
      reverseCurve: Curves.linear,
    );

// enum
enum ToastStates { success, error, warning }

Color chooseToastColor(ToastStates state) {
  Color color;

  switch (state) {
    case ToastStates.success:
      color = Colors.green;
      break;
    case ToastStates.error:
      color = Colors.red;
      break;
    case ToastStates.warning:
      color = Colors.amber;
      break;
  }

  return color;
}
