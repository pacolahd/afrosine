import 'package:afrosine/core/common/widgets/custom_button.dart';
import 'package:afrosine/core/common/widgets/headings.dart';
import 'package:afrosine/core/extensions/context_extension.dart';
import 'package:afrosine/core/resources/media_resources.dart';
import 'package:afrosine/src/dashboard/views/custom_bottom_nav_bar.dart';
import 'package:flutter/material.dart';

class GetStartedScreen extends StatefulWidget {
  const GetStartedScreen({super.key});
  static const routeName = '/get-started';
  @override
  State<GetStartedScreen> createState() => _GetStartedScreenState();
}

class _GetStartedScreenState extends State<GetStartedScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 50),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: context.width * 0.8,
                height: context.height * 0.24,
                child: const Image(
                  image: AssetImage(MediaRes.afrosineLogoNoBg),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              const H3DarkHeading(title: 'You are Welcome'),
              const SizedBox(
                height: 5,
              ),
              Text(
                'KCF Loves You!',
                style: context.theme.textStyles.title2,
              ),
              const SizedBox(
                height: 30,
              ),
              Container(
                width: context.width * 0.9,
                height: context.height * 0.28,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  image: const DecorationImage(
                      image: AssetImage(MediaRes.profileImagePlaceHolder),
                      fit: BoxFit.fill),
                ),
              ),
              const Spacer(),
              RedCustomIconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.pushNamed(context, CustomBottomNavBar.routeName);
                },
                labelText: 'Get In',
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
