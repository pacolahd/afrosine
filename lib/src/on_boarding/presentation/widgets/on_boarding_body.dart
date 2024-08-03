import 'package:afrosine/core/extensions/context_extension.dart';
import 'package:afrosine/core/resources/theme/app_colors.dart';
import 'package:afrosine/src/auth/presentation/views/sign_in_screen.dart';
import 'package:afrosine/src/on_boarding/domain/entities/page_content.dart';
import 'package:afrosine/src/on_boarding/presentation/cubit/on_boarding_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OnBoardingBody extends StatelessWidget {
  const OnBoardingBody({required this.pageContent, super.key});

  final PageContent pageContent;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8),
          child: Stack(
            children: [
              Container(
                height: context.height * .5,
                width: context.width,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: AppColors.orange,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  image: DecorationImage(
                    image: AssetImage(pageContent.backgroundImage),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    gradient: LinearGradient(
                      begin: Alignment.topRight,
                      colors: [
                        AppColors.orange.withOpacity(.6),
                        AppColors.milkyWhite.withOpacity(.1),
                      ],
                    ),
                  ),
                  child: Center(
                    child: Image.asset(pageContent.foregroundImage,
                        height: context.height * .35),
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: context.height * .1),
        Padding(
          padding: const EdgeInsets.all(20).copyWith(bottom: 0),
          child: Column(
            children: [
              Text(
                pageContent.title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: context.height * .02),
              Text(
                pageContent.description,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 14),
              ),
              SizedBox(height: context.height * .05),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 50,
                    vertical: 17,
                  ),
                  backgroundColor: AppColors.orange,
                  foregroundColor: Colors.white,
                ),
                onPressed: () {
                  context.read<OnBoardingCubit>().cacheFirstTimer();
                  Navigator.pushReplacementNamed(
                      context, SignInScreen.routeName);
                },
                child: const Text(
                  'Get Started',
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
