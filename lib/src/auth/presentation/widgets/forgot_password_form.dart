import 'package:afrosine/core/common/widgets/i_field.dart';
import 'package:afrosine/core/extensions/context_extension.dart';
import "package:flutter/material.dart";

class ForgotPasswordForm extends StatefulWidget {
  const ForgotPasswordForm({
    required this.emailController,
    required this.formKey,
    super.key,
  });
  final TextEditingController emailController;

  // to authenticate our form, we need a form and a formkey
  final GlobalKey<FormState> formKey;

  @override
  State<ForgotPasswordForm> createState() => _SignInFormState();
}

class _SignInFormState extends State<ForgotPasswordForm> {
  bool obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: Column(
        children: [
          IField(
            filled: true,
            fillColour: Colors.white,
            label: 'Email',
            controller: widget.emailController,
            hintText: 'Enter your Email',
            hintStyle: TextStyle(color: context.theme.colorScheme.onSecondary),
            keyboardType: TextInputType.emailAddress,
            overrideValidator: true,
          ),
        ],
      ),
    );
  }
}
