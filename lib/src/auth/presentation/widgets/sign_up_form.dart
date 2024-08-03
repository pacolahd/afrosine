import 'package:afrosine/core/common/widgets/i_field.dart';
import 'package:afrosine/core/extensions/context_extension.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';

class SignUpForm extends StatefulWidget {
  const SignUpForm({
    required this.emailController,
    required this.passwordController,
    required this.formKey,
    required this.userNameController,
    required this.repeatPasswordController,
    required this.scrollController,
    super.key,
  });

  final TextEditingController userNameController;
  final TextEditingController emailController;

  final TextEditingController passwordController;
  final TextEditingController repeatPasswordController;
  final GlobalKey<FormState> formKey;
  final ScrollController scrollController;

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  bool obscurePassword = true;

  final FocusNode _repeatPasswordFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _passwordFocusNode.addListener(_scrollToField);
    _repeatPasswordFocusNode.addListener(_scrollToField);
  }

  @override
  void dispose() {
    _repeatPasswordFocusNode.removeListener(_scrollToField);
    _repeatPasswordFocusNode.dispose();
    _passwordFocusNode.removeListener(_scrollToField);
    _passwordFocusNode.dispose();
    super.dispose();
  }

  void _scrollToField() {
    if (_passwordFocusNode.hasFocus || _repeatPasswordFocusNode.hasFocus) {
      // Scroll to the position of the "Repeat Password" field
      WidgetsBinding.instance.addPostFrameCallback((_) {
        widget.scrollController.animateTo(
          widget.scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      });
    } else {
      // Scroll back to the top when the "Repeat Password" field loses focus
      // WidgetsBinding.instance.addPostFrameCallback to ensure the scroll happens after the current frame is built
      WidgetsBinding.instance.addPostFrameCallback((_) {
        // When the frame is built, do this:
        widget.scrollController.animateTo(
          0,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: Column(
        children: [
          IField(
            filled: true,
            fillColour: context.theme.colorScheme.primary.withOpacity(.3),
            label: 'Username',
            controller: widget.userNameController,
            hintText: 'Username',
            hintStyle: TextStyle(
              color: context.theme.colorScheme.onSurface.withOpacity(.6),
            ),
            keyboardType: TextInputType.name,
          ),
          const SizedBox(
            height: 20,
          ),
          IField(
            filled: true,
            fillColour: context.theme.colorScheme.primary.withOpacity(.3),
            label: 'Email',
            controller: widget.emailController,
            hintText: 'example@gmail.com',
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
            hintText: '....................',
            hintStyle: TextStyle(
              color: context.theme.colorScheme.onSurface.withOpacity(.6),
            ),
            obscureText: obscurePassword,
            keyboardType: TextInputType.visiblePassword,
            focusNode: _passwordFocusNode,
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
          IField(
            filled: true,
            fillColour: context.theme.colorScheme.primary.withOpacity(.3),
            label: 'Repeat Password',
            controller: widget.repeatPasswordController,
            hintText: '....................',
            hintStyle: TextStyle(
              color: context.theme.colorScheme.onSurface.withOpacity(.6),
            ),
            obscureText: obscurePassword,
            keyboardType: TextInputType.visiblePassword,
            focusNode: _repeatPasswordFocusNode,
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
            overrideValidator: true,
            validator: (value) {
              if (value != widget.passwordController.text) {
                return 'Passwords do not match';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }
}
