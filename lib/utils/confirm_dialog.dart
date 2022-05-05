import 'package:flutter/material.dart';
import 'package:projects_archiving/view/widgets/app_button.dart';

class ConfirmDialog extends StatelessWidget {
  final VoidCallback onOkay;
  final String? title;
  const ConfirmDialog({Key? key, required this.onOkay, this.title})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title ?? "هل انت متاكد من اتمام العملية"),
      actionsAlignment: MainAxisAlignment.center,
      actions: [
        AppButton(
          text: 'موافق',
          onPressed: () {
            onOkay();
            Navigator.of(context).pop();
          },
          width: 100,
        ),
        AppButton(
          text: 'الغاء',
          buttonType: ButtonType.secondary,
          onPressed: Navigator.of(context).pop,
          width: 100,
        )
      ],
    );
  }
}
