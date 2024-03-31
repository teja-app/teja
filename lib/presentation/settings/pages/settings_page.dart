import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:go_router/go_router.dart';
import 'package:redux/redux.dart';
import 'package:teja/domain/redux/onboarding/actions.dart';
import 'package:teja/domain/redux/app_state.dart';
import 'package:teja/presentation/home/ui/master_fetch/fetch_master_view.dart';
import 'package:teja/presentation/navigation/buildMobileNavigationBar.dart';
import 'package:teja/presentation/navigation/isDesktop.dart';
import 'package:teja/router.dart';
import 'package:teja/shared/common/bento_box.dart';
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
    final GoRouter goRouter = GoRouter.of(context);
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

    return StoreConnector<AppState, ViewModel>(
      converter: ViewModel.fromStore,
      builder: (context, store) {
        return Scaffold(
          bottomNavigationBar: isDesktop(context) ? null : buildMobileNavigationBar(context),
          appBar: AppBar(
            title: const Text('Settings'),
          ),
          body: Center(
            child: SizedBox(
              width: contentWidth, // Set the content width
              child: ListView(
                children: <Widget>[
                  // Premium Banner
                  // Container(
                  //   margin: const EdgeInsets.all(10),
                  //   height: 300,
                  //   decoration: BoxDecoration(
                  //     borderRadius: BorderRadius.circular(10),
                  //     image: const DecorationImage(
                  //       image: AssetImage(
                  //           'assets/settings/banner.png'), // Replace 'assets/banner.jpg' with the path to your image
                  //       fit: BoxFit.cover,
                  //     ),
                  //   ),
                  // ),
                  // Personalize Section
                  if (!store.isFetchSuccessful)
                    const BentoBox(
                      gridWidth: 4,
                      gridHeight: 1.5,
                      child: FetchMasterView(),
                    ),
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text('Personalize', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                  // ListTile(
                  //   title: const Text('Preferences'),
                  //   onTap: () => GoRouter.of(context).push('/settings/perferences'),
                  // ),
                  // ListTile(
                  //   title: const Text('Notification Settings'),
                  //   onTap: () => GoRouter.of(context).push('/settings/notification'),
                  // ),
                  const Divider(),
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text('Data', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                  ListTile(
                    title: const Text('Data Sync - Export & Import'),
                    onTap: () => GoRouter.of(context).push('/settings/sync'),
                  ),
                  const Divider(),
                  ListTile(
                    title: const Text('Lock the app'),
                    onTap: () {
                      goRouter.goNamed(RootPath.root);
                    },
                  ),
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
                      _launchURL('https://discord.gg/Jvkqh97cfz');
                    },
                  ),
                  const Divider(),
                  // Help and Support Section
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text('Help and Support', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                  ListTile(
                    title: const Text('Report a bug'),
                    onTap: () {
                      _launchURL('https://swayamapp.atlassian.net/servicedesk/customer/portal/1/group/1/create/11');
                    },
                  ),
                  ListTile(
                    title: const Text('Suggest Imporvements'),
                    onTap: () {
                      _launchURL('https://swayamapp.atlassian.net/servicedesk/customer/portal/1/group/1/create/9');
                    },
                  ),
                  ListTile(
                    title: const Text('Suggest New Feature'),
                    onTap: () {
                      _launchURL('https://swayamapp.atlassian.net/servicedesk/customer/portal/1/group/1/create/12');
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
                      _launchURL('https://teja.app/terms');
                    },
                  ),
                  ListTile(
                    title: const Text('Privacy Policy'),
                    onTap: () {
                      _launchURL('https://teja.app/privacy');
                    },
                  ),
                  // ListTile(
                  //   title: const Text('Acknowledgement'),
                  //   onTap: () {
                  //     // Navigate to Acknowledgement sub-page
                  //   },
                  // ),
                  // ... Other application related settings
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class ViewModel {
  final DateTime? selectedDate;
  final bool isFetchSuccessful;

  ViewModel({
    this.selectedDate,
    required this.isFetchSuccessful,
  });

  static ViewModel fromStore(Store<AppState> store) {
    return ViewModel(
      selectedDate: store.state.homeState.selectedDate,
      isFetchSuccessful: store.state.masterFeelingState.isFetchSuccessful &&
          store.state.masterFactorState.isFetchSuccessful &&
          store.state.quoteState.isFetchSuccessful &&
          store.state.journalTemplateState.isFetchSuccessful,
    );
  }
}
