import 'package:afrosine/core/common/views/page_under_construction.dart';
import 'package:afrosine/core/extensions/context_extension.dart';
import 'package:afrosine/core/services/injection_container.dart';
import 'package:afrosine/src/auth/data/models/user_model.dart';
import 'package:afrosine/src/auth/presentation/bloc/auth_bloc.dart';
import 'package:afrosine/src/auth/presentation/views/forgot_password_screen.dart';
import 'package:afrosine/src/auth/presentation/views/get_started_screen.dart';
import 'package:afrosine/src/auth/presentation/views/sign_in_screen.dart';
import 'package:afrosine/src/auth/presentation/views/sign_up_screen.dart';
import 'package:afrosine/src/dashboard/views/custom_bottom_nav_bar.dart';
import 'package:afrosine/src/home/presentation/views/home_screen.dart';
import 'package:afrosine/src/home/presentation/views/recipe_search_screen.dart';
import 'package:afrosine/src/on_boarding/data/datasources/on_boarding_local_data_source.dart';
import 'package:afrosine/src/on_boarding/presentation/cubit/on_boarding_cubit.dart';
import 'package:afrosine/src/on_boarding/presentation/views/on_boarding_screen.dart';
import 'package:afrosine/src/recipe/presentation/bloc/recipe_bloc.dart';
import 'package:afrosine/src/recipe/presentation/views/recipe_details_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart' as fui;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../src/recipe/domain/entities/recipe.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    /*
      Here we want to check if the user is a first timer or not.
     if so, we show the onBoardingScreen,
      otherwise, we check if the user is logged in or not.
      if so, we show the home screen,
      otherwise, we show the login screen.

      We can only implement this logic iff we have the auth, login, and home screens ready.
    */

    case '/':
      // We can access all shared preferences here (even without needing to await) because we have already initialized the dependency injection container and we waited for it during the initialisation of the app.
      final prefs = sl<SharedPreferences>();
      return _pageBuilder(
        (context) {
          // If the user is a first timer, we want to push to the onBoardingScreen
          if (prefs.getBool(kFirstTimerKey) ?? true) {
            // We're injecting the cubit here because we want it to be available only to the OnBoardingScreen, and not to the entire app.
            return BlocProvider(
              create: (_) => sl<OnBoardingCubit>(),
              child: const OnBoardingScreen(),
            );
          }
          // If the user is already loggedIn, we want to push to the home screen
          // While doing so we also want to pass the userData to the home screen
          // We can't pass the firebase currentUser to the home screen like that
          // because it is a firebase variable and doesn't have all the user data like age, etc
          // So we need to create a user model and pass it to the home screen
          else if (sl<FirebaseAuth>().currentUser != null) {
            final user = sl<FirebaseAuth>().currentUser;
            final localUser = LocalUserModel(
              uid: user!.uid,
              email: user.email ?? '',
              userName: user.displayName ?? '',
              // TODO : Make sure the favourites are correctly handled

              favoriteRecipeIds: [],
            );
            context.userProvider.initUser(localUser);
            debugPrint('User: ${context.userProvider.user}');
            return const CustomBottomNavBar();
          }

          // If the user is not a first timer and not logged in, we want to push to the onBoardingScreen
          return BlocProvider(
            create: (_) => sl<OnBoardingCubit>(),
            child: const OnBoardingScreen(),
          );

          // If the user is not a first timer and not logged in, we want to push to the login screen
          // return BlocProvider(
          //   create: (_) => sl<AuthBloc>(),
          //   child: const SignInScreen(),
          // );
        },
        settings: settings,
      );
    case SignInScreen.routeName:
      return _pageBuilder(
        (_) => BlocProvider(
          create: (_) => sl<AuthBloc>(),
          child: const SignInScreen(),
        ),
        settings: settings,
      );

    case SignUpScreen.routeName:
      return _pageBuilder(
        (_) => BlocProvider(
          create: (_) => sl<AuthBloc>(),
          child: const SignUpScreen(),
        ),
        settings: settings,
      );

    case ForgotPasswordScreen.routeName:
      return _pageBuilder(
        (_) => const fui.ForgotPasswordScreen(),
        settings: settings,
      );

    case GetStartedScreen.routeName:
      return _pageBuilder(
        (_) => const GetStartedScreen(),
        settings: settings,
      );
    case CustomBottomNavBar.routeName:
      return _pageBuilder(
        (_) => const CustomBottomNavBar(),
        settings: settings,
      );
    case HomeScreen.routeName:
      return _pageBuilder(
        (_) => MultiBlocProvider(
          providers: [
            BlocProvider(create: (_) => sl<AuthBloc>()),
            BlocProvider(create: (_) => sl<RecipeBloc>()),
          ],
          child: HomeScreen(),
        ),
        settings: settings,
      );
    case RecipeSearchScreen.routeName:
      return _pageBuilder(
        (_) => MultiBlocProvider(
          providers: [
            BlocProvider(create: (_) => sl<AuthBloc>()),
            BlocProvider(create: (_) => sl<RecipeBloc>()),
          ],
          child: const RecipeSearchScreen(),
        ),
        settings: settings,
      );

    case RecipeDetailsScreen.routeName:
      final recipe = settings.arguments! as Recipe;
      return _pageBuilder(
        (_) => MultiBlocProvider(
          providers: [
            BlocProvider(create: (_) => sl<AuthBloc>()),
            BlocProvider(create: (_) => sl<RecipeBloc>()),
          ],
          child: RecipeDetailsScreen(recipe: recipe),
        ),
        settings: settings,
      );

    default:
      return _pageBuilder(
        (_) => const PageUnderConstruction(),
        settings: settings,
      );
  }
}

// flutter_form_builder: ^9.3.0
// form_builder_validators: ^10.0.1
// form_builder_extra_fields: ^10.2.0
// form_builder_image_picker: ^4.0.0

PageRouteBuilder<dynamic> _pageBuilder(
  // we want to collect the context too from the page we're coming from
  Widget Function(BuildContext) page, {
  // Collecting the route settings because we want to pass it to the PageRouteBuilder.
  required RouteSettings settings,
}) {
  return PageRouteBuilder(
    settings: settings,
    transitionsBuilder: (
      context,
      firstAnimation,
      secondAnimation,
      child,
    ) =>
        FadeTransition(
      opacity: firstAnimation,
      child: child,
    ),
    pageBuilder: (
      context,
      primaryAnimation,
      secondaryAnimation,
    ) =>
        page(context),
  );
}

// PageRouteBuilder<dynamic> _pageRouteBuilder(Widget page) {
//   return PageRouteBuilder(
//     pageBuilder: (context, animation, secondaryAnimation) => page,
//     transitionsBuilder: (context, animation, secondaryAnimation, child) {
//       const begin = Offset(1.0, 0.0);
//       const end = Offset.zero;
//       const curve = Curves.ease;
//       var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
//       var offsetAnimation = animation.drive(tween);
//       return SlideTransition(position: offsetAnimation, child: child);
//     },
//   );
// }
