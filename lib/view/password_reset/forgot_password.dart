import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:projects_archiving/app_router.gr.dart';
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

  @override
  void dispose() {
    _emailC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppHeader(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 600),
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
                'الرجاء ادخال بريدك الالكتروني\n'
                ' سوف يتم ارسال رابط اعادة تغيين كلمة السر الى بريدك الالكتروني',
                style: Theme.of(context).textTheme.titleMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              AppTextField(lableText: 'البريد الالكتروني', controller: _emailC),
              const SizedBox(height: 10),
              AppButton(
                width: 300,
                onPressed: () {
                  AutoRouter.of(context).pushNativeRoute(MaterialPageRoute(
                    builder: (c) => const OperationSuccessScreen(),
                  ));
                },
                text: 'ارسال',
              )
            ],
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
