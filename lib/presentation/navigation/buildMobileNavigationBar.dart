import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:icons_flutter/icons_flutter.dart';
import 'package:teja/router.dart';

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
        icon: Icon(
          AntDesign.appstore_o,
          weight: 100,
        ),
        label: 'Explore',
      ),
      BottomNavigationBarItem(
        icon: Icon(
          AntDesign.book,
          weight: 100,
        ),
        label: 'Journal',
      ),
      BottomNavigationBarItem(
        icon: Icon(
          AntDesign.user,
        ),
        label: 'Profile',
      ),
    ],
    currentIndex: _selectedIndex,
    onTap: (index) {
      switch (index) {
        case 0:
          goRouter.goNamed(RootPath.home);
          HapticFeedback.selectionClick();
          break;
        case 1:
          goRouter.goNamed(RootPath.explore);
          HapticFeedback.selectionClick();
          break;
        case 2:
          goRouter.goNamed(RootPath.timeLine);
          HapticFeedback.selectionClick();
          break;
        case 3:
          goRouter.goNamed(RootPath.profile);
          HapticFeedback.selectionClick();
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
    case '/explore':
      return 1;
    case '/mood_list':
      return 2;
    case '/profile':
      return 3;
    default:
      return 0; // Default index if no match found
  }
}
