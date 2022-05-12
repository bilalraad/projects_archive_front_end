import 'package:flutter/material.dart';
import 'package:projects_archiving/utils/confirm_dialog.dart';
import 'package:projects_archiving/utils/strings.dart';

extension BuildContextExtentions on BuildContext {
  ScaffoldFeatureController showSnackBar(
    String message, {
    bool isError = false,
    Color? color,
    SnackBarAction? action,
    Duration duration = const Duration(seconds: 2),
  }) =>
      ScaffoldMessenger.of(this).showSnackBar(
        SnackBar(
          content: Text(message),
          behavior: SnackBarBehavior.fixed,
          backgroundColor: color ?? (isError ? Colors.red : Colors.green),
          action: action,
          duration: duration,
        ),
      );

  void showConfirmDialog(VoidCallback onOkay,
          {String title = Strings.areYouSure}) =>
      showDialog(
        context: this,
        builder: (c) => ConfirmDialog(onOkay: onOkay, title: title),
      );
}
