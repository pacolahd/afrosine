import 'package:afrosine/core/common/widgets/custom_button.dart';
import 'package:afrosine/core/common/widgets/gradient_background.dart';
import 'package:afrosine/core/extensions/context_extension.dart';
import 'package:afrosine/core/resources/media_resources.dart';
import 'package:afrosine/src/auth/presentation/bloc/auth_bloc.dart';
import 'package:afrosine/src/auth/presentation/views/sign_in_screen.dart';
import 'package:afrosine/src/auth/presentation/widgets/sign_up_form.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});
  static const routeName = '/sign-up';

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final userNameController = TextEditingController();

  final emailController = TextEditingController();

  final passwordController = TextEditingController();
  final repeatPasswordController = TextEditingController();

  final formKey = GlobalKey<FormState>();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    userNameController.dispose();

    emailController.dispose();

    passwordController.dispose();
    repeatPasswordController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (_, state) {
          if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
              ),
            );
          } else if (state is SignedUp) {
            // If the user is signed up, we want to sign them in at once

            Navigator.pushReplacementNamed(
              context,
              SignInScreen.routeName,
            );

            // context.read<AuthBloc>().add(
            //       SignInEvent(
            //         email: emailController.text.trim(),
            //         password: passwordController.text.trim(),
            //       ),
            //     );
          }
          // else if (state is SignedIn) {
          //   // if the user is signed in, we want to push them to the home screen
          //   context.read<UserProvider>().initUser(state.user as LocalUserModel);
          //   Navigator.pushReplacementNamed(
          //     context,
          //     CustomBottomNavBar.routeName,
          //   );
          // }
        },
        builder: (context, state) {
          return GradientBackground(
            image: MediaRes.defaultBackground,
            child: Center(
              child: ListView(
                controller: _scrollController,
                // physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                children: [
                  // const SizedBox(
                  //   height: 50,
                  // ),
                  Align(
                    child: Text(
                      'Sign Up',
                      style: context.theme.textStyles.h3Bold
                          .copyWith(color: context.theme.colors.primary),
                    ),
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  SignUpForm(
                    emailController: emailController,
                    passwordController: passwordController,
                    formKey: formKey,
                    userNameController: userNameController,
                    repeatPasswordController: repeatPasswordController,
                    scrollController: _scrollController,
                  ),
                  const SizedBox(height: 45),
                  ButtonWithBottom(
                    button: state is AuthLoading
                        ? const Center(child: CircularProgressIndicator())
                        : CustomIconButton(
                            buttonRadius: 30,
                            label: Text(
                              'Sign up',
                              style: context.theme.textStyles.bodyBold.copyWith(
                                  color: context.theme.colors.milkyWhite),
                            ),
                            icon: Icon(Icons.arrow_back),
                            iconAlignment: IconAlignment.end,
                            onPressed: () {
                              FocusManager.instance.primaryFocus?.unfocus();
                              // in case the user has logged out in order to sign up for a new account
                              FirebaseAuth.instance.currentUser?.reload();

                              if (formKey.currentState!.validate()) {
                                // if the form is valid, we can proceed to authenticate the user
                                final userName = userNameController.text.trim();

                                final email = emailController.text.trim();

                                final password = passwordController.text.trim();

                                context.read<AuthBloc>().add(
                                      SignUpEvent(
                                        email: email,
                                        password: password,
                                        userName: userName,
                                      ),
                                    );
                              }
                            },
                          ),
                    bottom: BottomCTA(
                      onRightTextPressed: () {
                        Navigator.pushNamed(context, SignInScreen.routeName);
                      },
                      leftText: 'Already have an account? ',
                      rightText: 'Log In here',
                    ),
                  ),
                  // SizedBox(
                  //   height: 220,
                  // ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
