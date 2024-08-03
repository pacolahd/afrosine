import 'package:afrosine/core/extensions/context_extension.dart';
import 'package:flutter/material.dart';

class CoreUtils {
  const CoreUtils._();

  static void showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
      ..removeCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message,
              style: context.theme.textStyles.caption
                  .copyWith(color: context.theme.colorScheme.onPrimary)),
          behavior: SnackBarBehavior.floating,
          backgroundColor: context.theme.colorScheme.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          margin: const EdgeInsets.all(10),
        ),
      );
  }

  static void showLoadingDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  static void showMessageDialog(BuildContext context,
      {required String message, required String title}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  // static Future<File?> pickImage() async {
  //   final image = await ImagePicker().getImage(source: ImageSource.gallery);
  //   if (image != null) {
  //     return File(image.path);
  //   }
  //   return null;
  // }
}
