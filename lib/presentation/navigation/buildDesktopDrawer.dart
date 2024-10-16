import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:icons_flutter/icons_flutter.dart';
import 'package:teja/router.dart';

Widget buildDesktopNavigationBar(BuildContext context) {
  final GoRouter goRouter = GoRouter.of(context);
  final String location = GoRouterState.of(context).uri.toString();
  int _selectedIndex = _getSelectedIndex(location);

  final scaffoldBackgroundColor = Theme.of(context).scaffoldBackgroundColor;
  return NavigationRail(
    backgroundColor: scaffoldBackgroundColor,
    selectedIndex: _selectedIndex,
    onDestinationSelected: (int index) {
      switch (index) {
        case 0:
          goRouter.goNamed(RootPath.home);
          break;
        case 1:
          goRouter.goNamed(RootPath.explore);
          break;
        case 2:
          goRouter.goNamed(RootPath.timeLine);
          break;
        case 3:
          goRouter.goNamed(RootPath.profile);
          break;
        // Handle other indices as needed
      }
    },
    labelType: NavigationRailLabelType.all,
    destinations: const [
      NavigationRailDestination(
        icon: Icon(AntDesign.home),
        label: Text('Home'),
      ),
      NavigationRailDestination(
        icon: Icon(AntDesign.appstore_o, weight: 100),
        label: Text('Explore'),
      ),
      NavigationRailDestination(
        icon: Icon(AntDesign.book, weight: 100),
        label: Text('Journal'),
      ),
      NavigationRailDestination(
        icon: Icon(AntDesign.user),
        label: Text('Profile'),
      ),
      // Add other destinations as needed
    ],
  );
}

int _getSelectedIndex(String currentLocation) {
  switch (currentLocation) {
    case '/home':
      return 0;
    case '/explore':
      return 1;
    case '/timeline':
      return 2;
    case '/profile':
      return 3;
    default:
      return 0; // Default index if no match found
  }
}
