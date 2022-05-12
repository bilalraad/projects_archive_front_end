import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:projects_archiving/app_router.gr.dart';
import 'package:projects_archiving/blocs/user/user_cubit.dart';
import 'package:projects_archiving/utils/enums.dart';
import 'package:projects_archiving/utils/context_extentions.dart';
import 'package:projects_archiving/utils/strings.dart';
import 'package:projects_archiving/utils/validation_builder.dart';
import 'package:projects_archiving/view/add_admin/role_dropdown.dart';
import 'package:projects_archiving/view/widgets/app_button.dart';
import 'package:projects_archiving/view/widgets/app_header.dart';
import 'package:projects_archiving/view/widgets/app_text_feild.dart';

class AddAdminScreen extends StatefulWidget {
  const AddAdminScreen({Key? key}) : super(key: key);

  @override
  State<AddAdminScreen> createState() => _AddAdminScreenState();
}

class _AddAdminScreenState extends State<AddAdminScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _adminNameC, _adminEmailC, _adminPasswordC;
  late UserCubit _userB;
  Role _role = Role.admin;

  @override
  void initState() {
    super.initState();
    _userB = BlocProvider.of<UserCubit>(context);

    _adminNameC = TextEditingController();
    _adminEmailC = TextEditingController();
    _adminPasswordC = TextEditingController();
  }

  @override
  void dispose() {
    _adminNameC.dispose();
    _adminEmailC.dispose();
    _adminPasswordC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppHeader(
        child: Column(
          children: [
            Text(
              Strings.addAdmin,
              style: Theme.of(context)
                  .textTheme
                  .displayMedium
                  ?.copyWith(color: Colors.black),
            ),
            Expanded(
                child: Container(
              constraints: const BoxConstraints(maxWidth: 500),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    const SizedBox(height: 10),
                    AppTextField(
                      lableText: Strings.adminName,
                      controller: _adminNameC,
                      validator: ValidationBuilder().required().build(),
                    ),
                    const SizedBox(height: 10),
                    AppTextField(
                      lableText: Strings.email,
                      controller: _adminEmailC,
                      textAlign: TextAlign.left,
                      validator: ValidationBuilder().required().email().build(),
                    ),
                    const SizedBox(height: 10),
                    AppTextField(
                      lableText: Strings.password,
                      textAlign: TextAlign.left,
                      controller: _adminPasswordC,
                      validator:
                          ValidationBuilder().required().minLength(8).build(),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        RoleDropDown(
                            selectedRole: _role,
                            onRoleChanged: (r) => setState(() => _role = r!)),
                        const SizedBox(width: 10),
                        const Expanded(
                          child: Text(Strings.addAdminNote),
                        )
                      ],
                    ),
                    const SizedBox(height: 10),
                    AppButton(
                        width: 300,
                        isLoading: _userB.state.maybeWhen(
                            loading: () => true, orElse: () => false),
                        onPressed: () async {
                          if (!_formKey.currentState!.validate()) {
                            return;
                          }
                          await _userB.createUser(
                              email: _adminEmailC.text,
                              name: _adminNameC.text,
                              role: _role,
                              password: _adminPasswordC.text);
                          _userB.state.whenOrNull(data: (results) {
                            context.showSnackBar(Strings.adminAddedSuccess);
                            AutoRouter.of(context).replace(const MyHomeRoute());
                          }, failure: (e) {
                            context.showSnackBar(e.readableMessage,
                                isError: true);
                            return;
                          });
                        },
                        text: Strings.addAdmin),
                  ],
                ),
              ),
            )),
          ],
        ),
      ),
    );
  }
}
