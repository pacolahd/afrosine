import 'package:afrosine/core/common/widgets/custom_button.dart';
import 'package:afrosine/core/common/widgets/cutom_list_tile.dart';
import 'package:afrosine/core/common/widgets/headings.dart';
import 'package:flutter/material.dart';

class CustomInitialPage extends StatelessWidget {
  const CustomInitialPage(
      {required this.diaplayInformation,
      required this.title,
      required this.buttonLabel,
      required this.onPressed,
      super.key});
  static const routeName = '/user-needs-start-screen';

  final List<Map<String, String>> diaplayInformation;
  final String title;
  final String buttonLabel;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          child: Column(
            children: [
              const SizedBox(
                height: 50,
              ),
              Container(
                margin: const EdgeInsets.only(right: 10),
                child: H3DarkHeading(title: title),
              ),
              const SizedBox(
                height: 30,
              ),
              ListView.builder(
                // No need to specify itemCount here, it's implicit
                shrinkWrap: true, // Prevent excessive space below the list
                itemCount: diaplayInformation.length,
                itemBuilder: (context, index) {
                  return CustomListTile(
                    index: index + 1, // Adjust index for clarity
                    title: diaplayInformation[index]['title']!,
                    description: diaplayInformation[index]['description']!,
                  );
                },
              ),
              const Spacer(),
              RedCustomIconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: onPressed,
                labelText: buttonLabel,
              ),
              const SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
