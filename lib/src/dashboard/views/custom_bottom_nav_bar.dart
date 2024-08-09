import 'dart:async';

import 'package:afrosine/core/common/widgets/custom_list_tile_2.dart';
import 'package:afrosine/core/extensions/context_extension.dart';
import 'package:afrosine/core/services/injection_container.dart';
import 'package:afrosine/src/auth/presentation/bloc/auth_bloc.dart';
import 'package:afrosine/src/home/presentation/views/favourite_recipes_screen.dart';
import 'package:afrosine/src/home/presentation/views/home_screen.dart';
import 'package:afrosine/src/recipe/presentation/bloc/recipe_bloc.dart';
import 'package:afrosine/src/recipe/presentation/views/recipe_finder_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconly/iconly.dart';

class CustomBottomNavBar extends StatefulWidget {
  const CustomBottomNavBar({super.key});
  static const routeName = '/custom-bottom-nav-bar';

  @override
  State<CustomBottomNavBar> createState() => _CustomBottomNavBarState();
}

class _CustomBottomNavBarState extends State<CustomBottomNavBar> {
  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  late final List<Widget> _appSections = [
    // Home

    MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => sl<AuthBloc>()),
        BlocProvider(create: (_) => sl<RecipeBloc>()),
      ],
      child: HomeScreen(),
    ),

    BlocProvider(
      create: (_) => sl<RecipeBloc>(),
      child: RecipeFinderScreen(),
    ),

    BlocProvider(
      create: (_) => sl<RecipeBloc>(),
      child: FavoriteRecipesScreen(),
    ),
    // Profile
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => sl<AuthBloc>()),
      ],
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Center(
            child: Column(
              children: [
                const SizedBox(
                  height: 100,
                ),
                const Text('Profile'),
                Card(
                  margin: const EdgeInsets.all(20),
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: CustomListTile2(
                      leadingIcon: Icons.logout,
                      title: 'Logout',
                      value: true,
                      onPressed: () async {
                        final navigator = Navigator.of(context);
                        await FirebaseAuth.instance.signOut();
                        unawaited(
                          navigator.pushNamedAndRemoveUntil(
                            '/',
                            (route) => false,
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  ];

  int _selectedBottomAppBarIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedBottomAppBarIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final selectedItemColor =
        Theme.of(context).bottomNavigationBarTheme.selectedItemColor ??
            context.theme.colors.primary;
    final unselectedItemColor =
        Theme.of(context).bottomNavigationBarTheme.unselectedItemColor ??
            Colors.grey;

    final selectedLabelStyle =
        Theme.of(context).bottomNavigationBarTheme.selectedLabelStyle;
    final unSelectedLabelStyle =
        Theme.of(context).bottomNavigationBarTheme.unselectedLabelStyle;

    // return StreamBuilder<LocalUserModel>(
    //   stream: DashboardUtils.userDataStream,
    //   builder: (_, snapshot) {
    //     if (snapshot.hasData && snapshot.data is LocalUserModel) {
    //       context.read<UserProvider>().setUser(snapshot.data!);
    //
    //       debugPrint('Userbbbbbbbbbbbb: ${snapshot.data!.toJson()}');
    //       debugPrint('User: ${context.read<UserProvider>().user}');
    //     }
    return Scaffold(
      body: IndexedStack(
        index: _selectedBottomAppBarIndex,
        children: _appSections,
      ),
      bottomNavigationBar: BottomNavigationBar(
        showUnselectedLabels: true,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(
              _selectedBottomAppBarIndex == 0
                  ? IconlyBold.home
                  : IconlyLight.home,
              color:
                  _selectedBottomAppBarIndex == 0 ? Colors.orange : Colors.grey,
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              _selectedBottomAppBarIndex == 1
                  ? Icons.soup_kitchen_rounded
                  : Icons.soup_kitchen_outlined,
              color:
                  _selectedBottomAppBarIndex == 1 ? Colors.orange : Colors.grey,
            ),
            label: 'Recipe finder',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              _selectedBottomAppBarIndex == 2
                  ? Icons.bookmark
                  : Icons.bookmark_border_outlined,
              color:
                  _selectedBottomAppBarIndex == 2 ? Colors.orange : Colors.grey,
            ),
            label: 'Favourites',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              _selectedBottomAppBarIndex == 3
                  ? IconlyBold.profile
                  : IconlyLight.profile,
              color:
                  _selectedBottomAppBarIndex == 3 ? Colors.orange : Colors.grey,
            ),
            label: 'Profile',
          ),
        ],
        backgroundColor: context.theme.colorScheme.primary,
        currentIndex: _selectedBottomAppBarIndex,
        selectedLabelStyle: selectedLabelStyle,
        unselectedLabelStyle: unSelectedLabelStyle,
        onTap: _onItemTapped,
      ),
    );
    //   },
    // );
  }
}
