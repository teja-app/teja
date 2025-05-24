import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:teja/router.dart';
import 'package:teja/config/feature_flags.dart';

class MobileNavigationBar extends StatelessWidget {
  const MobileNavigationBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final GoRouter goRouter = GoRouter.of(context);
    final String location = GoRouterState.of(context).uri.toString();
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Build list of nav items dynamically based on feature flags
    final List<_NavItemData> navItems = [
      _NavItemData(Icons.home_outlined, RootPath.home, '/home'),
      if (FeatureFlags.exploreEnabled)
        _NavItemData(Icons.search, RootPath.explore, '/explore'),
      if (FeatureFlags.habitEnabled)
        _NavItemData(Icons.task_alt_outlined, RootPath.habit, '/habit'),
      _NavItemData(Icons.book, RootPath.timeLine, '/timeline'),
      _NavItemData(Icons.person_outline, RootPath.profile, '/profile'),
    ];

    // Find selected index based on current location
    int selectedIndex = navItems.indexWhere((item) => item.path == location);
    if (selectedIndex == -1) selectedIndex = 0;

    return Container(
      decoration: BoxDecoration(
        color: theme.navigationBarTheme.backgroundColor ?? colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withOpacity(0.1),
            spreadRadius: 0,
            blurRadius: 10,
            offset: Offset(0, -1),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: navItems.asMap().entries.map((entry) {
              final index = entry.key;
              final item = entry.value;
              return _buildNavItem(item.icon, index, selectedIndex, goRouter, theme, item.routeName);
            }).toList(),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, int index, int selectedIndex, GoRouter goRouter, ThemeData theme, String routeName) {
    final bool isSelected = selectedIndex == index;
    final colorScheme = theme.colorScheme;

    return GestureDetector(
      onTap: () {
        goRouter.goNamed(routeName);
        HapticFeedback.selectionClick();
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? colorScheme.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Icon(
          icon,
          color: isSelected ? colorScheme.onPrimary : colorScheme.onSurface.withOpacity(0.6),
          size: 24,
        ),
      ),
    );
  }

}

class _NavItemData {
  final IconData icon;
  final String routeName;
  final String path;

  _NavItemData(this.icon, this.routeName, this.path);
}
