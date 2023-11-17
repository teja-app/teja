import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:icons_flutter/icons_flutter.dart';
import 'package:swayam/router.dart';

Widget buildMobileNavigationBar(BuildContext context) {
  final GoRouter goRouter = GoRouter.of(context);
  final String location = GoRouterState.of(context).uri.toString();
  int _selectedIndex = _getSelectedIndex(location);

  return BottomNavigationBar(
    items: const <BottomNavigationBarItem>[
      BottomNavigationBarItem(
        icon: Icon(AntDesign.home),
        label: 'Home',
      ),
      BottomNavigationBarItem(
        icon: Icon(AntDesign.setting),
        label: 'Settings',
      ),
      BottomNavigationBarItem(
        icon: Icon(AntDesign.user),
        label: 'Profile',
      ),
      // Add other items as needed
    ],
    currentIndex: _selectedIndex,
    onTap: (index) {
      switch (index) {
        case 0:
          goRouter.goNamed(RootPath.home);
          break;
        case 1:
          goRouter.goNamed(RootPath.settings);
          break;
        case 2:
          goRouter.goNamed(RootPath.profile);
          break;
        // Handle other indices as needed
      }
    },
  );
}

int _getSelectedIndex(String currentLocation) {
  switch (currentLocation) {
    case '/home':
      return 0;
    case '/settings':
      return 1;
    case '/profile':
      return 2;
    default:
      return 0; // Default index if no match found
  }
}
