import 'package:afrosine/core/common/widgets/custom_button.dart';
import 'package:afrosine/core/common/widgets/headings.dart';
import 'package:afrosine/core/extensions/context_extension.dart';
import 'package:afrosine/core/resources/media_resources.dart';
import 'package:afrosine/src/auth/presentation/widgets/auth_background.dart';
import 'package:afrosine/src/auth/presentation/widgets/forgot_password_form.dart';
import 'package:flutter/material.dart';

import 'sign_up_screen.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  static const routeName = 'forgot-password';

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final emailController = TextEditingController();

  // to authenticate (validate) our form, we need a form and a formkey
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset:
          false, // This line prevents the page from resizing when keyboard appears

      body: AuthBackground(
          image: MediaRes.profileImagePlaceHolder,
          margin: const EdgeInsets.fromLTRB(20, 150, 20, 200),
          child: ListView(
            shrinkWrap: true,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            children: [
              const Align(
                child: H3Heading(title: 'Reset Password'),
              ),
              const SizedBox(height: 10),
              Text(
                  'Provide your email address and we will send you a link to reset your password',
                  style: context.theme.textStyles.body),
              const SizedBox(
                height: 25,
              ),
              ForgotPasswordForm(
                emailController: emailController,
                formKey: formKey,
              ),
              const SizedBox(height: 25),
              ButtonWithBottom(
                button: CustomIconButton(
                  label: Text(
                    'Reset',
                    style: context.theme.textStyles.bodyBold.copyWith(
                      color: context.theme.colors.milkyWhite,
                    ),
                  ),
                  icon: Icon(Icons.arrow_back),
                  iconAlignment: IconAlignment.end,
                  onPressed: () {},
                ),
                bottom: BottomCTA(
                  onRightTextPressed: () {
                    Navigator.pushNamed(context, SignUpScreen.routeName);
                  },
                  leftText: "Don't have an account? ",
                  rightText: 'Register here',
                ),
              )
            ],
          )),
    );
  }
}
