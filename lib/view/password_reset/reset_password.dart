import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:projects_archiving/utils/validation_builder.dart';
import 'package:projects_archiving/view/password_reset/forgot_password.dart';
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

  @override
  void dispose() {
    _emailC.dispose();
    _passwordC.dispose();
    _confirmPasswordC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                    validator: ValidationBuilder()
                        .required()
                        .equal(_passwordC.text, "كلمة السر")
                        .build()),
                const SizedBox(height: 10),
                AppButton(
                  width: 300,
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {}
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
