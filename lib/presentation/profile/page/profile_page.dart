import 'package:flutter/material.dart';
import 'package:teja/presentation/navigation/buildMobileNavigationBar.dart';
import 'package:teja/presentation/navigation/isDesktop.dart';
import 'package:teja/presentation/profile/ui/profile_weekly_mood_chart.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: isDesktop(context) ? null : buildMobileNavigationBar(context),
      appBar: AppBar(
        title: const Text('Profile'),
        forceMaterialTransparency: true,
      ),
      body: const SingleChildScrollView(
        key: Key("profileContainer"),
        padding: EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            ProfileWeeklyMoodChart(),
          ],
        ),
      ),
    );
  }
}
