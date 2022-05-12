import 'package:flutter/material.dart';
import 'package:projects_archiving/view/widgets/app_button.dart';
import 'package:projects_archiving/view/widgets/app_text_feild.dart';

class KeyWordsWidget extends StatelessWidget {
  const KeyWordsWidget(
      {Key? key,
      required this.onKeyWordAdded,
      required this.onkeyWordDeleted,
      required this.keywords})
      : super(key: key);

  final void Function(String) onKeyWordAdded;
  final void Function(String) onkeyWordDeleted;
  final List<String> keywords;

  @override
  Widget build(BuildContext context) {
    final keyWordController = TextEditingController();
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              flex: 3,
              child: AppTextField(
                lableText: 'مثال: تطبيق هاتف',
                controller: keyWordController,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              flex: 1,
              child: AppButton(
                  text: 'اضافة',
                  buttonType: ButtonType.secondary,
                  onPressed: () {
                    if (keyWordController.text.isNotEmpty) {
                      onKeyWordAdded(keyWordController.text);
                      keyWordController.clear();
                    }
                  }),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Theme.of(context).dividerColor),
            borderRadius: BorderRadius.circular(10),
          ),
          height: 200,
          width: double.infinity,
          child: GridView.count(
            crossAxisCount: 2,
            childAspectRatio: 30 / 10,
            children: keywords.map((e) {
              return Container(
                margin: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor.withOpacity(.4),
                  border: Border.all(color: Theme.of(context).primaryColor),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(e),
                    ),
                    const Spacer(),
                    IconButton(
                        onPressed: () => onkeyWordDeleted(e),
                        padding: const EdgeInsets.all(0),
                        icon: const Icon(Icons.delete))
                  ],
                ),
              );
            }).toList(),
          ),
        )
      ],
    );
  }
}
