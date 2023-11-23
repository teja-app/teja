import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:icons_flutter/icons_flutter.dart';
import 'package:swayam/router.dart';

Widget buildDesktopDrawer(BuildContext context) {
  final GoRouter goRouter = GoRouter.of(context);
  final String location = GoRouterState.of(context).uri.toString();
  int _selectedIndex =
      _getSelectedIndex(location); // Utilize the same logic as in mobile

  return Drawer(
    child: ListView(
      padding: EdgeInsets.zero,
      children: <Widget>[
        _buildDrawerItem(
          icon: AntDesign.home,
          title: 'Home',
          onTap: () => goRouter.goNamed(RootPath.home),
          selected: _selectedIndex == 0,
        ),
        _buildDrawerItem(
          icon: AntDesign.setting,
          title: 'Settings',
          onTap: () => goRouter.goNamed(RootPath.settings),
          selected: _selectedIndex == 1,
        ),
        _buildDrawerItem(
          icon: Feather.compass,
          title: 'Mood',
          onTap: () => goRouter.goNamed(RootPath.moodList),
          selected: _selectedIndex == 2,
        ),
        _buildDrawerItem(
          icon: AntDesign.user,
          title: 'Profile',
          onTap: () => goRouter.goNamed(RootPath.profile),
          selected: _selectedIndex == 3,
        ),
        // Add other items as needed
      ],
    ),
  );
}

Widget _buildDrawerItem(
    {required IconData icon,
    required String title,
    required Function() onTap,
    required bool selected}) {
  return ListTile(
    leading: Icon(
      icon,
      weight: 100,
    ),
    title: Text(title),
    onTap: onTap,
    selected: selected,
  );
}

int _getSelectedIndex(String currentLocation) {
  switch (currentLocation) {
    case '/home':
      return 0;
    case '/settings':
      return 1;
    case '/mood_list':
      return 2;
    case '/profile':
      return 3;
    default:
      return 0; // Default index if no match found
  }
}
