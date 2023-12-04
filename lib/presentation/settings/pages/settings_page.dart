import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:go_router/go_router.dart';
import 'package:redux/redux.dart';
import 'package:teja/domain/redux/onboarding/actions.dart';
import 'package:teja/domain/redux/app_state.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  // Function to launch URL
  void _launchURL(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double contentWidth = (screenWidth > 500) ? 500 : screenWidth; // Assuming 500 is the max width for content

    Widget _logout(BuildContext context) {
      return StoreConnector<AppState, Store<AppState>>(
        converter: (store) => store,
        builder: (context, store) {
          return ListTile(
            title: const Text('Logout'),
            onTap: () {
              store.dispatch(SignOutAction());
            },
          );
        },
      );
    }

    return Scaffold(
        appBar: AppBar(
          title: const Text('Settings'),
        ),
        body: Center(
          child: SizedBox(
            width: contentWidth, // Set the content width
            child: ListView(
              children: <Widget>[
                // Premium Banner
                Container(
                  margin: const EdgeInsets.all(10),
                  height: 300,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    image: const DecorationImage(
                      image: AssetImage(
                          'assets/settings/banner.png'), // Replace 'assets/banner.jpg' with the path to your image
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                // Personalize Section
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text('Personalize', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
                ListTile(
                  title: const Text('Preferences'),
                  onTap: () => GoRouter.of(context).push('/settings/perferences'),
                ),
                ListTile(
                  title: const Text('Notification Settings'),
                  onTap: () => GoRouter.of(context).push('/settings/notification'),
                ),
                const Divider(),

                // Account Section
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text('Account', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
                ListTile(
                  title: const Text('Basic'),
                  onTap: () => GoRouter.of(context).push('/settings/basic'),
                ),
                ListTile(
                  title: const Text('Security'),
                  onTap: () => GoRouter.of(context).push('/settings/security'),
                ),
                ListTile(
                  title: const Text('Advanced Account Settings'),
                  onTap: () => GoRouter.of(context).push('/settings/advanced'),
                ),
                _logout(context),
                const Divider(),
                // Community Section
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text('Community', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
                ListTile(
                  title: const Text('Share Teja'),
                  onTap: () {
                    _launchURL('https://teja.app');
                  },
                ),
                ListTile(
                  title: const Text('Join Discord Community'),
                  onTap: () {
                    _launchURL('https://discord.gg/XtekVBqP');
                  },
                ),
                const Divider(),
                // Help and Support Section
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text('Help and Support', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
                ListTile(
                  title: const Text('Report a Bug'),
                  onTap: () {
                    // Navigate to bug report form or open email template
                  },
                ),
                const Divider(),

                // Application Section
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text('Application', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
                ListTile(
                  title: const Text('Terms of Service'),
                  onTap: () {
                    _launchURL('https://terms-of-service-link.com');
                  },
                ),
                ListTile(
                  title: const Text('Privacy Policy'),
                  onTap: () {
                    _launchURL('https://privacy-policy-link.com');
                  },
                ),
                ListTile(
                  title: const Text('Acknowledgement'),
                  onTap: () {
                    // Navigate to Acknowledgement sub-page
                  },
                ),
                // ... Other application related settings
              ],
            ),
          ),
        ));
  }
}
