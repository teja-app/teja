import 'package:flutter/material.dart';
import 'package:teja/presentation/navigation/buildDesktopDrawer.dart';
import 'package:teja/presentation/navigation/buildMobileNavigationBar.dart';
import 'package:teja/presentation/navigation/isDesktop.dart';
import 'package:teja/presentation/navigation/leadingContainer.dart';
import 'package:teja/presentation/profile/ui/profile_weekly_mood_chart.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    const mainBody = SingleChildScrollView(
      key: Key("profileContainer"),
      child: Column(
        children: <Widget>[
          ProfileWeeklyMoodChart(),
        ],
      ),
    );
    return Scaffold(
      bottomNavigationBar: isDesktop(context) ? null : buildMobileNavigationBar(context),
      appBar: AppBar(
        title: const Text('Profile'),
        forceMaterialTransparency: true,
        leading: leadingNavBar(context),
        leadingWidth: 72,
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
