import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:teja/presentation/navigation/buildDesktopDrawer.dart';
import 'package:teja/presentation/navigation/mobile_navigation_bar.dart';
import 'package:teja/presentation/navigation/isDesktop.dart';
import 'package:teja/presentation/navigation/leadingContainer.dart';
import 'package:teja/presentation/profile/page/profile_main_body.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    const mainBody = MainBody();

    return Scaffold(
      bottomNavigationBar: isDesktop(context) ? null : const MobileNavigationBar(),
      appBar: AppBar(
        title: const Text('Profile'),
        forceMaterialTransparency: true,
        leading: leadingNavBar(context),
        leadingWidth: 72,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings), // Settings icon
            onPressed: () {
              GoRouter.of(context).push("/settings");
            },
          ),
        ],
      ),
      body: isDesktop(context)
          ? Row(
              children: [
                buildDesktopNavigationBar(context), // The NavigationRail
                const Expanded(
                  child: Align(
                    alignment: Alignment.topCenter, // Adjust this as needed
                    child: mainBody,
                  ),
                ), // Main content area
              ],
            )
          : mainBody,
    );
  }
}
