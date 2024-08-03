import 'package:afrosine/core/resources/media_resources.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class PageUnderConstruction extends StatelessWidget {
  const PageUnderConstruction({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        constraints: const BoxConstraints.expand(),
        child: SafeArea(
          child: Center(
            child: Lottie.asset(MediaRes.pageUnderConstruction),
          ),
        ),
      ),
    );
  }
}
