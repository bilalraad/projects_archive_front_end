import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:projects_archiving/app_router.gr.dart';
import 'package:projects_archiving/blocs/user/user_cubit.dart';
import 'package:projects_archiving/utils/snack_bar.dart';
import 'package:projects_archiving/utils/strings.dart';
import 'package:projects_archiving/view/project/project_details/project_details.dart';
import 'package:projects_archiving/view/widgets/app_button.dart';
import 'package:projects_archiving/view/widgets/app_text_feild.dart';

class LogInScreen extends StatefulWidget {
  const LogInScreen({Key? key}) : super(key: key);

  @override
  State<LogInScreen> createState() => _LogInScreenState();
}

class _LogInScreenState extends State<LogInScreen> {
  late UserCubit _userB;
  final _formKey = GlobalKey<FormState>();

  final emailC = TextEditingController();
  final passwordC = TextEditingController();

  @override
  void initState() {
    _userB = BlocProvider.of<UserCubit>(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Wrap(
          children: [
            Container(
              height: double.infinity,
              constraints: BoxConstraints(
                  maxWidth: 500, maxHeight: MediaQuery.of(context).size.height),
              margin: const EdgeInsets.symmetric(horizontal: 10),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    const AppBackButton(),
                    const Spacer(),
                    AppTextField(
                      lableText: 'البريد الالكتروني',
                      controller: emailC,
                    ),
                    const SizedBox(height: 10),
                    AppTextField(
                      lableText: 'كلمة السر',
                      controller: passwordC,
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

                          await _userB.logIn(
                              email: emailC.text, password: passwordC.text);
                          _userB.state.whenOrNull(data: (results) {
                            context.showSnackBar('تم تسجيل الدخول بنجاح');
                            AutoRouter.of(context).replace(const MyHomeRoute());
                          }, failure: (e) {
                            context.showSnackBar(e.readableMessage,
                                isError: true);
                            return;
                          });
                        },
                        text: Strings.logIn),
                    const Spacer(),
                  ],
                ),
              ),
            ),
            Container(
              color: Colors.orange,
              height: double.infinity,
              constraints: BoxConstraints(
                  maxWidth: 500, maxHeight: MediaQuery.of(context).size.height),
            )
          ],
        ),
      ),
    );
  }
}
