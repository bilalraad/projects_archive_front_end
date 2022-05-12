import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:projects_archiving/app_router.gr.dart';
import 'package:projects_archiving/blocs/password_manager/password_manager_cubit.dart';
import 'package:projects_archiving/utils/context_extentions.dart';
import 'package:projects_archiving/utils/strings.dart';
import 'package:projects_archiving/utils/validation_builder.dart';
import 'package:projects_archiving/view/project/project_details/project_details.dart';
import 'package:projects_archiving/view/widgets/app_button.dart';
import 'package:projects_archiving/view/widgets/app_text_feild.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _emailC = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  late PasswordManagerCubit _forgetB;

  @override
  void dispose() {
    _emailC.dispose();
    _forgetB.reset();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _forgetB = BlocProvider.of<PasswordManagerCubit>(context, listen: true);

    return Scaffold(
      body: AppHeader(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 600),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Text(
                  Strings.resetPassword,
                  style: Theme.of(context)
                      .textTheme
                      .displayMedium
                      ?.copyWith(color: Colors.black),
                ),
                Text(
                  Strings.resetPasswordSubTitle,
                  style: Theme.of(context).textTheme.titleMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                AppTextField(
                  lableText: Strings.email,
                  controller: _emailC,
                  validator: ValidationBuilder().required().email().build(),
                ),
                const SizedBox(height: 10),
                AppButton(
                  width: 300,
                  isLoading: _forgetB.state
                      .maybeWhen(loading: () => true, orElse: () => false),
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      await _forgetB.sendForgotPasswordEmail(_emailC.text);
                      _forgetB.state.whenOrNull(data: (_) {
                        AutoRouter.of(context).pushNativeRoute(
                          MaterialPageRoute(
                            builder: (c) => const OperationSuccessScreen(),
                          ),
                        );
                      }, failure: (e) {
                        context.showSnackBar(e.readableMessage, isError: true);
                        return;
                      });
                    }
                  },
                  text: Strings.send,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class AppHeader extends StatelessWidget {
  final Widget child;
  const AppHeader({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10),
        constraints: const BoxConstraints(maxWidth: 1000),
        child: Column(
          children: [const AppBackButton(), Expanded(child: child)],
        ),
      ),
    );
  }
}

class OperationSuccessScreen extends StatelessWidget {
  final String? title;
  const OperationSuccessScreen({Key? key, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title ?? 'تم اكمال العملية بنجاح',
              style: Theme.of(context)
                  .textTheme
                  .displayMedium
                  ?.copyWith(color: Colors.black),
            ),
            const SizedBox(height: 20),
            AppButton(
              width: 300,
              onPressed: () {
                AutoRouter.of(context).replace(const MyHomeRoute());
              },
              text: 'العودة الى الرئيسية',
            )
          ],
        ),
      ),
    );
  }
}
