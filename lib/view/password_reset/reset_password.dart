import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:projects_archiving/app_router.gr.dart';
import 'package:projects_archiving/blocs/password_manager/password_manager_cubit.dart';
import 'package:projects_archiving/models/reset_password.dart';
import 'package:projects_archiving/utils/context_extentions.dart';
import 'package:projects_archiving/utils/validation_builder.dart';
import 'package:projects_archiving/view/widgets/app_button.dart';
import 'package:projects_archiving/view/widgets/app_text_feild.dart';

class ResetPasswordScreen extends StatefulWidget {
  final String token;
  const ResetPasswordScreen({
    Key? key,
    @PathParam('token') required this.token,
  }) : super(key: key);

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _emailC = TextEditingController();
  final _passwordC = TextEditingController();
  final _confirmPasswordC = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  late PasswordManagerCubit _forgetB;

  @override
  void dispose() {
    _emailC.dispose();
    _passwordC.dispose();
    _confirmPasswordC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _forgetB = BlocProvider.of<PasswordManagerCubit>(context, listen: true);
    return Scaffold(
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 600),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Text(
                  'اعادة تعيين كلمة المرور',
                  style: Theme.of(context)
                      .textTheme
                      .displayMedium
                      ?.copyWith(color: Colors.black),
                ),
                Text(
                  'الرجاء اعد ادخال بريدك الالكتروني\n'
                  'مع كلمة السر الجديدة',
                  style: Theme.of(context).textTheme.titleMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                AppTextField(
                  lableText: 'البريد الالكتروني',
                  controller: _emailC,
                  validator: ValidationBuilder().required().email().build(),
                ),
                const SizedBox(height: 10),
                AppTextField(
                    lableText: 'كلمة السر الجديدة',
                    controller: _passwordC,
                    validator:
                        ValidationBuilder().required().minLength(8).build()),
                const SizedBox(height: 10),
                AppTextField(
                    lableText: 'تاكيد كلمة السر',
                    controller: _confirmPasswordC,
                    validator: (v) {
                      return ValidationBuilder()
                          .required()
                          .equal(_passwordC.text, "كلمة السر")
                          .build()
                          .call(v);
                    }),
                const SizedBox(height: 10),
                AppButton(
                  width: 300,
                  isLoading: _forgetB.state
                      .maybeWhen(loading: () => true, orElse: () => false),
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      await _forgetB.resetPassword(
                          data: ResetPassword(
                        email: _emailC.text,
                        token: widget.token,
                        password: _passwordC.text,
                        passwordConfirmation: _confirmPasswordC.text,
                      ));

                      _forgetB.state.whenOrNull(data: (_) async {
                        await context
                            .showSnackBar("تم تغيير كلمة السر بنجاح")
                            .closed;
                        if (!mounted) return;
                        AutoRouter.of(context).replace(const LogInRoute());
                      }, failure: (e) {
                        context.showSnackBar(e.readableMessage, isError: true);
                        return;
                      });
                    }
                  },
                  text: 'تغيير كلمة السر',
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
