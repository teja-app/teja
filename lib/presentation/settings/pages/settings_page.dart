import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:redux/redux.dart';
import 'package:teja/domain/redux/app_state.dart';
import 'package:teja/presentation/home/ui/master_fetch/fetch_master_view.dart';
import 'package:teja/presentation/settings/pages/widgets/settings_authenticate.dart';
import 'package:teja/router.dart';
import 'package:teja/shared/common/flexible_height_box.dart';
import 'package:teja/theme/theme_service.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

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
    final ThemeService themeService =
        Provider.of<ThemeService>(context, listen: false);
    final double screenWidth = MediaQuery.of(context).size.width;
    final double contentWidth = (screenWidth > 500) ? 500 : screenWidth;

    return StoreConnector<AppState, ViewModel>(
      converter: ViewModel.fromStore,
      builder: (context, store) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Settings'),
            forceMaterialTransparency: true,
          ),
          body: Center(
            child: SizedBox(
              width: contentWidth,
              child: ListView(
                children: <Widget>[
                  if (!store.isFetchSuccessful)
                    const FlexibleHeightBox(
                      gridWidth: 4,
                      disableBackground: true,
                      child: FetchMasterView(),
                    ),
                  _buildSection('Personalization', [
                    _buildListTile(
                      'Theme',
                      Icons.palette,
                      () => _showThemeOptions(context, themeService),
                    ),
                    _buildListTile(
                      'Notification Settings',
                      Icons.notifications,
                      () => GoRouter.of(context).push('/settings/notification'),
                    ),
                  ]),
                  _buildSection('Security', [
                    _buildListTile(
                      'Lock the app',
                      Icons.lock,
                      () => goRouter.goNamed(RootPath.root),
                    ),
                    _buildListTile(
                      'Recovery Codes',
                      Icons.security,
                      () => _authenticateAndNavigate(
                          context, '/settings/recovery-code'),
                    ),
                  ]),
                  _buildSection('Data Management', [
                    _buildListTile(
                      'Data Sync - Export & Import',
                      Icons.sync,
                      () => _authenticateAndNavigate(context, '/settings/sync'),
                    ),
                    _buildListTile(
                      'Advanced',
                      Icons.settings,
                      () => _authenticateAndNavigate(
                          context, '/settings/advanced'),
                    ),
                  ]),
                  _buildSection('Community', [
                    _buildListTile(
                      'Share Teja',
                      Icons.share,
                      () => _launchURL('https://teja.app'),
                    ),
                    _buildListTile(
                      'Join Discord Community',
                      Icons.group,
                      () => _launchURL('https://discord.gg/Jvkqh97cfz'),
                    ),
                  ]),
                  _buildSection('Help and Support', [
                    _buildListTile(
                      'Report a bug',
                      Icons.bug_report,
                      () => _launchURL(
                          'https://swayamapp.atlassian.net/servicedesk/customer/portal/1/group/1/create/11'),
                    ),
                    _buildListTile(
                      'Suggest Improvements',
                      Icons.lightbulb,
                      () => _launchURL(
                          'https://swayamapp.atlassian.net/servicedesk/customer/portal/1/group/1/create/9'),
                    ),
                    _buildListTile(
                      'Suggest New Feature',
                      Icons.new_releases,
                      () => _launchURL(
                          'https://swayamapp.atlassian.net/servicedesk/customer/portal/1/group/1/create/12'),
                    ),
                  ]),
                  _buildSection('Legal', [
                    _buildListTile(
                      'Terms of Service',
                      Icons.description,
                      () => _launchURL('https://teja.app/terms'),
                    ),
                    _buildListTile(
                      'Privacy Policy',
                      Icons.privacy_tip,
                      () => _launchURL('https://teja.app/privacy'),
                    ),
                  ]),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        ...children,
        const Divider(),
      ],
    );
  }

  Widget _buildListTile(String title, IconData icon, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      onTap: onTap,
    );
  }

  void _showThemeOptions(BuildContext context, ThemeService themeService) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: const Text('Choose Theme'),
          children: <Widget>[
            SimpleDialogOption(
              onPressed: () {
                themeService.setThemeMode(ThemeMode.light);
                Navigator.pop(context);
              },
              child: const Text('Light Theme'),
            ),
            SimpleDialogOption(
              onPressed: () {
                themeService.setThemeMode(ThemeMode.dark);
                Navigator.pop(context);
              },
              child: const Text('Dark Theme'),
            ),
          ],
        );
      },
    );
  }

  void _authenticateAndNavigate(BuildContext context, String route) {
    settingsAuthenticate(context, () {
      GoRouter.of(context).push(route);
    });
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
