import 'package:flutter/material.dart';

enum ButtonType {
  primary,
  secondary,
}

class AppButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String text;
  final double? width;
  final Widget? icon;
  final Color? textColor;
  final Color? backroundColor;
  final ButtonType buttonType;

  const AppButton(
      {Key? key,
      required this.onPressed,
      required this.text,
      this.buttonType = ButtonType.primary,
      this.width,
      this.textColor,
      this.backroundColor,
      this.icon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isPrimary = buttonType == ButtonType.primary;
    final defaultTextColor = isPrimary
        ? Theme.of(context).colorScheme.surface
        : Theme.of(context).colorScheme.primary;

    final buttonBgColor = isPrimary
        ? Theme.of(context).colorScheme.primary
        : Theme.of(context).colorScheme.background;
    return ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
            primary: backroundColor ?? buttonBgColor,
            shape: RoundedRectangleBorder(
                side: isPrimary
                    ? BorderSide.none
                    : BorderSide(
                        width: 2,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                borderRadius: BorderRadius.circular(5))),
        child: Stack(
          alignment: Alignment.centerRight,
          children: [
            Positioned(
              right: 10,
              child: icon ?? const SizedBox(),
            ),
            Container(
              width: width,
              height: 50,
              padding: const EdgeInsets.all(3),
              alignment: Alignment.center,
              child: Text(
                text,
                style: const TextStyle()
                    .copyWith(color: textColor ?? defaultTextColor),
              ),
            ),
          ],
        ));
  }
}
