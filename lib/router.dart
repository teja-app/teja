import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:teja/infrastructure/analytics/analytics_service.dart';
import 'package:teja/presentation/explore/list/pages/explore_page.dart';
import 'package:teja/presentation/explore/list/pages/search_page.dart';
import 'package:teja/presentation/goal_editor/page/vision_picker_page.dart';
import 'package:teja/presentation/home/pages/home_page.dart';
import 'package:teja/presentation/journal/journa_detail/pages/journal_detail_page.dart';
import 'package:teja/presentation/journal/journal_categories/categories_detail_page.dart';
import 'package:teja/presentation/journal/journal_categories/categories_page.dart';
import 'package:teja/presentation/journal/journal_editor/pages/journal_editor_page.dart';
import 'package:teja/presentation/journal/journal_editor/pages/journal_entry_page.dart';
import 'package:teja/presentation/journal/journal_editor/pages/quick_journal_entry_page.dart';
import 'package:teja/presentation/mood/detail/page/mood_detail.dart';
import 'package:teja/presentation/mood/editor/pages/mood_edit.dart';
import 'package:teja/presentation/music/ui/SimpleMusicPlayer.dart';
import 'package:teja/presentation/registration/page/RecoverAccountScreen.dart';
import 'package:teja/presentation/registration/page/RegistrationScreen.dart';
import 'package:teja/presentation/profile/page/profile_page.dart';
import 'package:teja/presentation/settings/pages/recovery_code_page.dart';
import 'package:teja/presentation/settings/pages/notification_settings_page.dart';
import 'package:teja/presentation/task/page/task_list.dart';
import 'package:teja/presentation/timeline/pages/timeline_list_page.dart';
import 'package:teja/presentation/mood/share/pages/mood_share.dart';
import 'package:teja/presentation/note_editor/note_editor_page.dart';
import 'package:teja/presentation/onboarding/pages/onboarding_page.dart';
import 'package:teja/presentation/quotes/random_quote.dart';
import 'package:teja/presentation/settings/pages/advanced_settings_page.dart';
import 'package:teja/presentation/settings/pages/basic_settings_page.dart';
import 'package:teja/presentation/settings/pages/perference_settings_page.dart';
import 'package:teja/presentation/settings/pages/security_settings_page.dart';
import 'package:teja/presentation/settings/pages/settings_page.dart';
import 'package:teja/presentation/settings/pages/sync_settings_page.dart';
import 'package:teja/shared/helpers/logger.dart';
import 'package:teja/config/shared_config.dart';

class RouteLoggingObserver extends NavigatorObserver {
  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    // Log when a new route is pushed onto the navigator stack
    logger.i('Pushed route: ${route.settings.name}');
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    // Log when a route is popped from the navigator stack
    logger.i('Popped route: ${route.settings.name}');
  }
}

class SettingPath {
  static const notification = "notification";
  static const sync = "sync";
  static const perferences = "perferences";
  static const basic = "basic";
  static const security = "security";
  static const advanced = "advanced";
  static const recoveryCode = "recovery-code";
}

class RootPath {
  static const root = "root";
  static const registration = "registration";
  static const recoveryAccount = "recoveryAccount";
  static const signIn = "signIn";
  static const home = "home";
  static const music = "music";
  static const habit = "habit";
  static const profile = "profile";
  static const explore = "explore";
  static const exploreSearch = "explore_search";
  static const guide = "guide";
  static const journal = "journal";
  static const echo = "echo";
  static const comingSoon = "coming_soon";
  static const inspiration = "inspiration";
  static const settings = "settings";
  static const moodEdit = "mood_edit";
  static const timeLine = "timeline";
  static const moodDetail = "mood_detail";
  static const journalCategory = "journal_categories";
  static const journalCategoryDetail = "journal_categories_detail";
  static const moodShare = "mood_share";
  static const goalSettings = "goal_settings";
  static const noteEditor = "note_editor";
  static const journalEditor = "journal_editor";
  static const quickJournalEntry = "quickJournalEntry";
  static const journalDetail = "journal_detail";
  static const journalEntryPage = "journal_entry_page";
}

final _rootNavigatorKey = GlobalKey<NavigatorState>();

class AnalyticsRouteObserver extends NavigatorObserver {
  final AnalyticsService _analyticsService;

  AnalyticsRouteObserver(this._analyticsService);

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    _sendScreenView(route, event: 'didPush');
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    if (previousRoute != null) {
      _sendScreenView(previousRoute, event: 'didPop');
    }
  }

  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) {
    _sendScreenView(route, event: 'didRemove');
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    if (newRoute != null) {
      _sendScreenView(newRoute, event: 'didReplace');
    }
  }

  @override
  void didStartUserGesture(Route<dynamic> route, Route<dynamic>? previousRoute) {
    _analyticsService.track('didStartUserGesture', {
      'currentRoute': route.settings.name ?? 'Unknown',
      'previousRoute': previousRoute?.settings.name ?? 'Unknown',
    });
  }

  @override
  void didStopUserGesture() {
    _analyticsService.track('didStopUserGesture', {});
  }

  void _sendScreenView(Route<dynamic> route, {required String event}) {
    final String screenName = route.settings.name ?? 'Unknown';
    _analyticsService.screen(
      screenName,
      {
        'path': screenName,
        'route': route.settings.toString(),
        'event': event,
      },
    );
  }
}

class HeroPageRoute<T> extends CustomTransitionPage<T> {
  HeroPageRoute({
    required Widget child,
    required String heroTag,
  }) : super(
          child: child,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return Hero(
              tag: heroTag,
              child: child,
              flightShuttleBuilder: (
                BuildContext flightContext,
                Animation<double> animation,
                HeroFlightDirection flightDirection,
                BuildContext fromHeroContext,
                BuildContext toHeroContext,
              ) {
                return Material(
                  color: Colors.transparent,
                  child: toHeroContext.widget,
                );
              },
            );
          },
        );
}

GoRouter createRouter(AnalyticsService analyticsService) {
  return GoRouter(
    // initialLocation: initialLocation, // Use the initialLocation parameter here
    debugLogDiagnostics: true,
    observers: [
      RouteLoggingObserver(),
      AnalyticsRouteObserver(analyticsService),
    ],
    navigatorKey: _rootNavigatorKey,
    routes: [
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        name: RootPath.root,
        path: '/',
        builder: (context, state) => const OnboardingPage(),
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        name: RootPath.noteEditor,
        path: '/note_editor',
        builder: (context, state) => const NoteEditorPage(),
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        name: RootPath.registration,
        path: '/registration',
        builder: (context, state) => RegistrationScreen(),
      ),
      GoRoute(
        path: '/recover-account',
        name: RootPath.recoveryAccount,
        builder: (context, state) => RecoverAccountScreen(),
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        name: RootPath.journalEditor, // Define a constant for this route
        path: '/journal_editor',
        builder: (context, state) => const JournalEditorScreen(),
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        name: RootPath.journalEntryPage,
        path: '/journal_entry_page/:id',
        builder: (context, state) => JournalEntryPage(
          journalEntryId: state.pathParameters['id']!,
        ),
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        name: RootPath.journalCategory, // Define a constant for this route
        path: '/journal_categories',
        builder: (context, state) => const JournalCategoriesPage(),
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        name: RootPath.home,
        path: '/home',
        builder: (context, state) => const HomePage(),
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        name: RootPath.habit,
        path: '/habit',
        builder: (context, state) => TaskList(),
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        name: RootPath.music,
        path: '/music',
        builder: (context, state) => const SimplePlayerScreen(),
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        name: RootPath.explore,
        path: '/explore',
        builder: (context, state) => const ExplorePage(),
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        name: RootPath.exploreSearch,
        path: '/explore_search',
        builder: (context, state) => const SearchPage(),
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        name: RootPath.inspiration,
        path: '/inspiration',
        builder: (context, state) => RandomQuotePage(),
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        name: RootPath.moodEdit,
        path: '/mood_edit',
        builder: (context, state) => const MoodEditPage(),
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        name: RootPath.timeLine,
        path: '/timeline',
        builder: (context, state) => const TimelinePage(),
      ),
      GoRoute(
        // Add this block for mood detail page
        parentNavigatorKey: _rootNavigatorKey,
        name: RootPath.moodDetail,
        path: '/mood_detail',
        builder: (context, state) {
          final String? moodIdStr = state.uri.queryParameters['id'];
          return MoodDetailPage(moodId: moodIdStr!);
        },
      ),
      GoRoute(
        // Add this block for mood detail page
        parentNavigatorKey: _rootNavigatorKey,
        name: RootPath.moodShare,
        path: '/mood_share',
        builder: (context, state) {
          final String? moodIdStr = state.uri.queryParameters['id'];
          return MoodSharePage(moodId: moodIdStr!);
        },
      ),
      GoRoute(
        name: 'quickJournalEntry',
        path: '/quick-journal-entry',
        pageBuilder: (context, state) {
          final String? entryId = state.uri.queryParameters['id'];
          final String heroTag = (state.extra as Map<String, dynamic>?)?['heroTag'] ?? 'defaultHeroTag';
          return HeroPageRoute(
            heroTag: heroTag,
            child: QuickJournalEntryScreen(entryId: entryId, heroTag: heroTag),
          );
        },
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        name: RootPath.journalCategoryDetail, // Make sure you have this constant defined
        path: '/category_detail',
        builder: (context, state) {
          final String? categoryId = state.uri.queryParameters['id'];
          if (categoryId != null) {
            return CategoryDetailPage(categoryId: categoryId);
          } else {
            // Handle the case where categoryId is null, maybe navigate back or show an error
            return const Scaffold(body: Center(child: Text('Category not found')));
          }
        },
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        name: RootPath.goalSettings,
        path: '/goal_settings',
        builder: (context, state) => const VisionPickerPage(),
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        name: RootPath.journalDetail,
        path: '/journal_detail',
        builder: (context, state) {
          final String? journalEntryId = state.uri.queryParameters['id'];
          return JournalDetailPage(journalEntryId: journalEntryId!);
        },
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        name: RootPath.profile,
        path: '/profile',
        builder: (context, state) => const ProfilePage(),
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        name: RootPath.settings,
        path: '/settings',
        builder: (context, state) => const SettingsPage(),
        routes: [
          GoRoute(
            name: SettingPath.sync,
            path: 'sync',
            builder: (context, state) => const SyncSettingsPage(),
          ),
          GoRoute(
            name: SettingPath.perferences,
            path: 'perferences',
            builder: (context, state) => const PreferencesSettingsPage(),
          ),
          GoRoute(
            name: SettingPath.notification,
            path: 'notification',
            builder: (context, state) => NotificationSettingsPage(
              notificationService: notificationService,
            ),
          ),
          GoRoute(
            name: SettingPath.basic,
            path: 'basic',
            builder: (context, state) => const BasicSettingsPage(),
          ),
          GoRoute(
            name: SettingPath.security,
            path: 'security',
            builder: (context, state) => const SecuritySettingsPage(),
          ),
          GoRoute(
            name: SettingPath.advanced,
            path: 'advanced',
            builder: (context, state) => const AdvancedSettingsPage(),
          ),
          GoRoute(
            path: SettingPath.recoveryCode,
            name: 'recover',
            builder: (context, state) => RecoveryCodePage(),
          ),
        ],
      ),
    ],
  );
}
