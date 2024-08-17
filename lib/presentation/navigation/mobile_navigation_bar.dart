import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:teja/router.dart';

class MobileNavigationBar extends StatelessWidget {
  const MobileNavigationBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final GoRouter goRouter = GoRouter.of(context);
    final String location = GoRouterState.of(context).uri.toString();
    int selectedIndex = _getSelectedIndex(location);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

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
            children: [
              _buildNavItem(Icons.home_outlined, 0, selectedIndex, goRouter, theme),
              _buildNavItem(Icons.search, 1, selectedIndex, goRouter, theme),
              _buildNavItem(Icons.task_alt_outlined, 2, selectedIndex, goRouter, theme),
              _buildNavItem(Icons.book, 3, selectedIndex, goRouter, theme),
              _buildNavItem(Icons.person_outline, 4, selectedIndex, goRouter, theme),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, int index, int selectedIndex, GoRouter goRouter, ThemeData theme) {
    final bool isSelected = selectedIndex == index;
    final colorScheme = theme.colorScheme;

    return GestureDetector(
      onTap: () {
        switch (index) {
          case 0:
            goRouter.goNamed(RootPath.home);
            break;
          case 1:
            goRouter.goNamed(RootPath.explore);
            break;
          case 2:
            goRouter.goNamed(RootPath.habit);
            break;
          case 3:
            goRouter.goNamed(RootPath.timeLine);
            break;
          case 5:
            goRouter.goNamed(RootPath.profile);
            break;
        }
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

  int _getSelectedIndex(String currentLocation) {
    switch (currentLocation) {
      case '/home':
        return 0;
      case '/explore':
        return 1;
      case '/habit':
        return 2;
      case '/timeline':
        return 3;
      case '/profile':
        return 4;
      default:
        return 0;
    }
  }
}
