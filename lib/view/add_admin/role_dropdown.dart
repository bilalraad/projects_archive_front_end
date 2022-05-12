import 'package:flutter/material.dart';
import 'package:projects_archiving/utils/enums.dart';
import 'package:projects_archiving/utils/strings.dart';

class RoleDropDown extends StatelessWidget {
  const RoleDropDown(
      {Key? key, required this.selectedRole, required this.onRoleChanged})
      : super(key: key);

  final Role? selectedRole;
  final Function(Role?) onRoleChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 160,
      height: 70,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
          border: Border.all(color: Theme.of(context).dividerColor),
          borderRadius: BorderRadius.circular(10)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('مستوى الصلاحية'),
          DropdownButtonFormField<Role>(
              isDense: true,
              icon: const SizedBox.shrink(),
              decoration: const InputDecoration.collapsed(
                hintText: '',
                border: InputBorder.none,
              ),
              items: Role.values
                  .map((e) => DropdownMenuItem<Role>(
                      value: e,
                      child: Text(
                        Strings.translateRole(e),
                        style: Theme.of(context).textTheme.subtitle1?.copyWith(
                            color: Theme.of(context).primaryColor, height: .5),
                      )))
                  .toList(),
              value: selectedRole,
              onChanged: onRoleChanged),
        ],
      ),
    );
  }
}
