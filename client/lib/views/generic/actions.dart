import 'package:tcord/views/generic/templates.dart';
import 'package:tcord/views/generic/themes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

Future showCustomGeneralDialog(
    BuildContext context, Widget icon, String title, String okText,
    {String? message,
    String ?cancelText,
    Function ?okPressed,
    Function ?cancelPressed,
    bool dismissible = true,
    double top = 30.0}) async {
  await showGeneralDialog(
      barrierDismissible: dismissible,
      barrierColor: AppTheme.DarkJungleGreen.withOpacity(0.4),
      barrierLabel: '',
      transitionDuration: Duration(milliseconds: 400),
      context: context,
      pageBuilder: (context, animation1, animation2) => SizedBox.shrink(),
      transitionBuilder: (context, a1, a2, widget) {
        final curvedValue = Curves.easeInOutCubic.transform(a1.value) - 1.0;
        return Transform(
          transform: Matrix4.translationValues(0.0, curvedValue * -50, 0.0),
          child: Opacity(
            opacity: a1.value,
            child: ResultPopup(
              icon: icon,
              okText: okText,
              title: title,
              message: message??"",
              cancelText: cancelText??"",
              okPressed: okPressed,
              cancelPressed: cancelPressed,
              top: top,
            ),
          ),
        );
      });
}

Future showPopup(
    {required BuildContext context,
    required Widget child,
    bool dismissible = true,
    double backgroundOpacity = 0.4}) async {
  await showGeneralDialog(
      barrierDismissible: dismissible,
      barrierColor: AppTheme.DarkJungleGreen.withOpacity(backgroundOpacity),
      barrierLabel: '',
      transitionDuration: Duration(milliseconds: 400),
      context: context,
      pageBuilder: (context, animation1, animation2) => SizedBox.shrink(),
      transitionBuilder: (context, a1, a2, widget) {
        final curvedValue = Curves.easeInOutCubic.transform(a1.value) - 1.0;
        return Transform(
          transform: Matrix4.translationValues(0.0, curvedValue * -50, 0.0),
          child: Opacity(opacity: a1.value, child: child),
        );
      });
}
