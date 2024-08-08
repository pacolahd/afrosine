import 'package:afrosine/core/common/app/providers/user_provider.dart';
import 'package:afrosine/core/common/widgets/custom_button.dart';
import 'package:afrosine/core/common/widgets/gradient_background.dart';
import 'package:afrosine/core/extensions/context_extension.dart';
import 'package:afrosine/core/resources/media_resources.dart';
import 'package:afrosine/core/utils/core_utils.dart';
import 'package:afrosine/src/auth/data/models/user_model.dart';
import 'package:afrosine/src/auth/presentation/bloc/auth_bloc.dart';
import 'package:afrosine/src/auth/presentation/views/sign_up_screen.dart';
import 'package:afrosine/src/auth/presentation/widgets/sign_in_form.dart';
import 'package:afrosine/src/dashboard/views/custom_bottom_nav_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'forgot_password_screen.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  static const routeName = '/sign-in';

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // to authenticate (validate) our form, we need a form and a formkey
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset:
          false, // This line prevents the page from resizing when keyboard appears
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthError) {
            CoreUtils.showSnackBar(context, state.message);
          } else if (state is SignedIn) {
            // we don't want to push the user to the home screen if the user is not signed in
            context.read<UserProvider>().initUser(state.user as LocalUserModel);
            Navigator.pushReplacementNamed(
              context,
              CustomBottomNavBar.routeName,
            );
          }
        },
        builder: (context, state) {
          return GradientBackground(
              image: MediaRes.defaultBackground,
              child: Center(
                child: ListView(
                  shrinkWrap: true,
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  children: [
                    Image(
                      image: const AssetImage(MediaRes.afrosineLogo),
                      width: context.width * .1,
                    ),
                    Align(
                      child: Text(
                        'Welcome Back!',
                        style: context.theme.textStyles.h3Bold
                            .copyWith(color: context.theme.colors.primary),
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    SignInForm(
                      emailController: emailController,
                      passwordController: passwordController,
                      formKey: formKey,
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            ForgotPasswordScreen.routeName,
                          );
                        },
                        child: Text(
                          'Forgot password ?',
                          style: context.theme.textStyles.caption.copyWith(
                            color: context.theme.colors.primary,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 45,
                    ),
                    ButtonWithBottom(
                      button: state is AuthLoading
                          ? const Center(
                              child: CircularProgressIndicator(),
                            )
                          : CustomIconButton(
                              buttonRadius: 30,
                              label: Text(
                                'Log in',
                                style: context.theme.textStyles.bodyBold
                                    .copyWith(
                                        color: context.theme.colors.milkyWhite),
                              ),
                              icon: const Icon(
                                Icons.arrow_forward,
                                color: Colors.white,
                              ),
                              iconAlignment: IconAlignment.end,
                              onPressed: () {
                                FocusManager.instance.primaryFocus?.unfocus();
                                // delete the user if someone was signed in before
                                FirebaseAuth.instance.currentUser?.reload();

                                if (formKey.currentState!.validate()) {
                                  // if the form is valid, we can proceed to authenticate the user
                                  context.read<AuthBloc>().add(
                                        SignInEvent(
                                          email: emailController.text.trim(),
                                          password:
                                              passwordController.text.trim(),
                                        ),
                                      );
                                  // we can't push the user to the home screen here because we don't know if the user is signed in
                                  // we will listen to the state and push the user to the home screen if the user is signed in

                                  // emailController.clear();
                                  // passwordController.clear();
                                }
                              },
                            ),
                      bottom: BottomCTA(
                        onRightTextPressed: () {
                          Navigator.pushNamed(context, SignUpScreen.routeName);
                        },
                        leftText: "Don't have an account? ",
                        rightText: 'Register here',
                      ),
                    ),
                  ],
                ),
              ));
        },
      ),
    );
  }
}
