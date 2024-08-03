import 'package:afrosine/core/common/app/providers/user_provider.dart';
import 'package:afrosine/core/resources/theme/app_colors.dart';
import 'package:afrosine/core/resources/theme/app_theme_theme.dart';
import 'package:afrosine/src/auth/domain/entities/user.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

extension ContextExtension on BuildContext {
  ThemeData get theme => Theme.of(this);

  MediaQueryData get mediaQuery => MediaQuery.of(this);

  Size get size => mediaQuery.size;
  double get width => size.width;
  double get height => size.height;

  UserProvider get userProvider => read<UserProvider>();

  LocalUser? get currentUser => userProvider.user;
}

extension CustomThemeData on ThemeData {
  AppTextTheme get textStyles {
    // check how to remove the ! mark i.e making it non-nullable

    return extension<AppTextTheme>()!;
  }

  AppColorsExtension get colors => AppColorsExtension();
}

class AppColorsExtension {
  Color get primary => AppColors.orange;
  Color get dark => AppColors.dark;
  Color get white => AppColors.white;
  Color get milkyWhite => AppColors.milkyWhite;
}

String truncateString(String text, {int maxLength = 13}) {
  if (text.length <= maxLength) {
    return text;
  } else {
    return text.substring(0, maxLength) + '...';
  }
}
