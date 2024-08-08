import 'package:flutter/material.dart';

class ErrorView extends StatelessWidget {
  const ErrorView({required this.error, super.key});
  final String error;

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: Center(
        child: Text('An error occurred: $error'),
      ),
    );
  }
}
