import 'package:afrosine/core/common/widgets/i_field.dart';
import 'package:afrosine/core/extensions/context_extension.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';

class SignInForm extends StatefulWidget {
  const SignInForm({
    required this.emailController,
    required this.passwordController,
    required this.formKey,
    super.key,
  });
  final TextEditingController emailController;
  final TextEditingController passwordController;

  // to authenticate our form, we need a form and a formkey
  final GlobalKey<FormState> formKey;

  @override
  State<SignInForm> createState() => _SignInFormState();
}

class _SignInFormState extends State<SignInForm> {
  bool obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: Column(
        children: [
          IField(
            filled: true,
            fillColour: context.theme.colorScheme.primary.withOpacity(.3),
            label: 'Email',
            controller: widget.emailController,
            hintText: 'Enter your Email',
            hintStyle: TextStyle(
              color: context.theme.colorScheme.onSurface.withOpacity(.6),
            ),
            keyboardType: TextInputType.emailAddress,
            overrideValidator: true,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'This field is required';
              }
              if (!value.contains('@')) {
                return 'Enter a valid email address';
              }
              return null;
            },
          ),
          const SizedBox(
            height: 20,
          ),
          IField(
            filled: true,
            fillColour: context.theme.colorScheme.primary.withOpacity(.3),
            label: 'Password',
            controller: widget.passwordController,
            hintText: 'Enter your Password',
            hintStyle: TextStyle(
              color: context.theme.colorScheme.onSurface.withOpacity(.6),
            ),
            obscureText: obscurePassword,
            keyboardType: TextInputType.visiblePassword,
            suffixIcon: IconButton(
              icon: Icon(
                obscurePassword ? IconlyLight.show : IconlyLight.hide,
              ),
              onPressed: () {
                setState(() {
                  obscurePassword = !obscurePassword;
                });
              },
            ),
          ),
          const SizedBox(
            height: 8,
          ),
        ],
      ),
    );
  }
}
