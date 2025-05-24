import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:icons_flutter/icons_flutter.dart';
import 'package:teja/router.dart';
import 'package:teja/config/feature_flags.dart';

Widget buildDesktopNavigationBar(BuildContext context) {
  final GoRouter goRouter = GoRouter.of(context);
  final String location = GoRouterState.of(context).uri.toString();

  // Build navigation items dynamically
  final List<_NavRailItem> navItems = [
    _NavRailItem(AntDesign.home, 'Home', RootPath.home, '/home'),
    if (FeatureFlags.exploreEnabled)
      _NavRailItem(AntDesign.appstore_o, 'Explore', RootPath.explore, '/explore'),
    _NavRailItem(AntDesign.book, 'Journal', RootPath.timeLine, '/timeline'),
    _NavRailItem(AntDesign.user, 'Profile', RootPath.profile, '/profile'),
  ];

  // Find selected index
  int selectedIndex = navItems.indexWhere((item) => item.path == location);
  if (selectedIndex == -1) selectedIndex = 0;

  final scaffoldBackgroundColor = Theme.of(context).scaffoldBackgroundColor;
  return NavigationRail(
    backgroundColor: scaffoldBackgroundColor,
    selectedIndex: selectedIndex,
    onDestinationSelected: (int index) {
      if (index < navItems.length) {
        goRouter.goNamed(navItems[index].routeName);
      }
    },
    labelType: NavigationRailLabelType.all,
    destinations: navItems.map((item) => NavigationRailDestination(
      icon: Icon(item.icon, weight: 100),
      label: Text(item.label),
    )).toList(),
  );
}

class _NavRailItem {
  final IconData icon;
  final String label;
  final String routeName;
  final String path;

  _NavRailItem(this.icon, this.label, this.routeName, this.path);
}
