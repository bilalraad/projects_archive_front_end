import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:projects_archiving/app_router.gr.dart';
import 'package:projects_archiving/blocs/user/user_cubit.dart';
import 'package:projects_archiving/utils/assets.dart';
import 'package:projects_archiving/utils/snack_bar.dart';
import 'package:projects_archiving/utils/strings.dart';
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
  bool isObscure = true;

  @override
  void initState() {
    _userB = BlocProvider.of<UserCubit>(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Wrap(
          alignment: WrapAlignment.spaceBetween,
          runAlignment: WrapAlignment.center,
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width >= 1200
                  ? MediaQuery.of(context).size.width * 0.5
                  : MediaQuery.of(context).size.width,
              child: Stack(
                children: [
                  Positioned(
                    top: 20,
                    right: 20,
                    child: Image.asset(Assets.appLogo, width: 80),
                  ),
                  Container(
                    height: double.infinity,
                    constraints: BoxConstraints(
                        maxHeight: MediaQuery.of(context).size.height),
                    margin: const EdgeInsets.symmetric(horizontal: 50),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          const Spacer(),
                          Text(
                            Strings.logIn,
                            style: Theme.of(context)
                                .textTheme
                                .displaySmall
                                ?.copyWith(color: Colors.black),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'اذا كنت ادمن الرجاء اثبات هويتك عن طريق التسجيل',
                            style: Theme.of(context).textTheme.titleLarge,
                            textAlign: TextAlign.center,
                          ),
                          const Spacer(),
                          AppTextField(
                            lableText: 'البريد الالكتروني',
                            controller: emailC,
                            textAlign: TextAlign.left,
                          ),
                          const SizedBox(height: 10),
                          AppTextField(
                            lableText: 'كلمة السر',
                            controller: passwordC,
                            obscureText: isObscure,
                            textAlign: TextAlign.left,
                            suffixIcon: InkWell(
                              onTap: () =>
                                  setState(() => isObscure = !isObscure),
                              child: Icon(isObscure
                                  ? Icons.visibility_off
                                  : Icons.visibility),
                            ),
                          ),
                          const SizedBox(height: 10),
                          AppButton(
                              width: 300,
                              backroundColor: Colors.black,
                              isLoading: _userB.state.maybeWhen(
                                  loading: () => true, orElse: () => false),
                              onPressed: () async {
                                if (!_formKey.currentState!.validate()) {
                                  return;
                                }

                                await _userB.logIn(
                                    email: emailC.text,
                                    password: passwordC.text);
                                _userB.state.whenOrNull(data: (results) {
                                  context.showSnackBar('تم تسجيل الدخول بنجاح');
                                  AutoRouter.of(context)
                                      .replace(const MyHomeRoute());
                                }, failure: (e) {
                                  context.showSnackBar(e.readableMessage,
                                      isError: true);
                                  return;
                                });
                              },
                              text: Strings.logIn),
                          const SizedBox(height: 10),
                          AppButton(
                              width: 300,
                              buttonType: ButtonType.secondary,
                              onPressed: () {
                                AutoRouter.of(context)
                                    .replace(const MyHomeRoute());
                              },
                              text: 'تصفح الموقع فقط'),
                          const Spacer(),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width >= 1200
                  ? MediaQuery.of(context).size.width * 0.5
                  : MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  border: Border.all(
                      color: Theme.of(context).primaryColor.withOpacity(0.5),
                      width: 20),
                  image: const DecorationImage(
                      image: AssetImage(Assets.zipImage))),
              alignment: Alignment.centerLeft,
              constraints:
                  BoxConstraints(maxHeight: MediaQuery.of(context).size.height),
              child: Stack(
                children: [
                  Positioned(
                    top: 20,
                    left: 20,
                    child: Image.asset(
                      Assets.collegeLogo,
                      width: 100,
                    ),
                  ),
                  Center(
                    child: Column(
                      children: [
                        const Spacer(),
                        Text(
                          'كل شيء مؤرشف',
                          style: Theme.of(context)
                              .textTheme
                              .displayMedium
                              ?.copyWith(color: Colors.black),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'اهلا بك في ارشيف مشاريع جامعة النهرين كلية هندسة الحاسبات',
                          style: Theme.of(context).textTheme.titleMedium,
                          textAlign: TextAlign.center,
                        ),
                        const Spacer(),
                      ],
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
