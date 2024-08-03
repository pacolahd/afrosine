import 'package:afrosine/core/extensions/context_extension.dart';
import 'package:flutter/material.dart';

class CustomListTile extends StatelessWidget {
  const CustomListTile({
    required this.index,
    required this.title,
    required this.description,
    super.key,
  });
  final int index;
  final String title;
  final String description;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: 20),
            child: Text(
              '$index',
              style: context.theme.textStyles.title2Bold.copyWith(
                color: context.theme.colorScheme.secondary,
              ),
            ),
          ),
          const SizedBox(
            width: 30,
          ),
          SizedBox(
            width: context.width * 0.8,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: context.theme.textStyles.title2Bold.copyWith(
                    color: context.theme.colorScheme.secondary,
                  ),
                ),
                Text(
                  description,
                  softWrap: true,
                  style: context.theme.textStyles.body.copyWith(
                    color: context.theme.colorScheme.tertiary,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class CustomListTileWithIcon extends StatelessWidget {
  const CustomListTileWithIcon({
    required this.title,
    required this.icon,
    super.key,
  });
  final Widget icon;
  final String title;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: context.theme.textStyles.body.copyWith(
              color: context.theme.colorScheme.tertiary,
            ),
          ),
          icon,
        ],
      ),
    );
  }
}
