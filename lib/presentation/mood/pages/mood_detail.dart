import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:go_router/go_router.dart';
import 'package:icons_flutter/icons_flutter.dart';
import 'package:intl/intl.dart';
import 'package:redux/redux.dart';
import 'package:swayam/domain/redux/app_state.dart';
import 'package:swayam/domain/redux/mood/detail/mood_detail_actions.dart';
import 'package:swayam/domain/redux/mood/detail/mood_detail_state.dart';

class MoodDetailPage extends StatefulWidget {
  final String moodId;

  const MoodDetailPage({
    Key? key,
    required this.moodId,
  }) : super(key: key);

  @override
  _MoodDetailPageState createState() => _MoodDetailPageState();
}

class _MoodDetailPageState extends State<MoodDetailPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Store<AppState> store = StoreProvider.of<AppState>(context);
      store.dispatch(LoadMoodDetailAction(widget.moodId));
    });
  }

  void _showErrorSnackbar(BuildContext context, String? errorMessage) {
    if (errorMessage != null && errorMessage.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage)),
      );
    }
  }

  @override
  Widget build(BuildContext pageContext) {
    return StoreConnector<AppState, MoodDetailState>(
      converter: (store) => store.state.moodDetailPage,
      onInitialBuild: (moodDetailPage) {
        if (moodDetailPage.errorMessage != null) {
          _showErrorSnackbar(pageContext, moodDetailPage.errorMessage);
        }
      },
      builder: (_, moodDetailPage) {
        Widget bodyContent = const Center(child: CircularProgressIndicator());
        // Check if feelings list is not null and not empty
        List<Widget> feelingsWidgets = [];
        if (moodDetailPage.selectedMoodLog!.feelings != null &&
            moodDetailPage.selectedMoodLog!.feelings!.isNotEmpty) {
          feelingsWidgets = moodDetailPage.selectedMoodLog!.feelings!
              .map((feeling) => Text(feeling.feeling))
              .toList();
        }
        if (moodDetailPage.selectedMoodLog != null) {
          bodyContent = Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  DateFormat(
                    'dd-MMM-yyyy, h:mm a',
                  ).format(
                    moodDetailPage.selectedMoodLog!.timestamp,
                  ),
                  style: const TextStyle(
                    color: Colors.black54,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(
                  height: 24,
                ),
                const Text(
                  'mood entry',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 34,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 48,
                ),
                const Text(
                  'Mood',
                  style: TextStyle(color: Colors.grey, fontSize: 22),
                ),
                const SizedBox(
                  height: 8,
                ),
                Text(
                  '${moodDetailPage.selectedMoodLog?.moodRating}/5',
                  style: const TextStyle(color: Colors.black, fontSize: 24),
                ),
                if (feelingsWidgets.isNotEmpty) ...[
                  const SizedBox(height: 24),
                  const Text(
                    'Feelings',
                    style: TextStyle(color: Colors.grey, fontSize: 22),
                  ),
                  const SizedBox(height: 8),
                  ...feelingsWidgets,
                ],
              ],
            ),
          );
        } else if (moodDetailPage.errorMessage != null) {
          bodyContent = Center(
            child: Text(moodDetailPage.errorMessage ?? 'Something went wrong!'),
          );
        }
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            iconTheme: const IconThemeData(color: Colors.black),
            actions: [
              PopupMenuButton<int>(
                key: const Key("mood_settings"),
                icon: const Icon(
                  AntDesign.ellipsis1,
                  color: Colors.black,
                  size: 16,
                ),
                onSelected: (int result) {
                  if (result == 0) {
                  } else if (result == 1) {
                    showDialog(
                      context: pageContext,
                      builder: (BuildContext dialogContext) {
                        return AlertDialog(
                          title: const Text('Confirm Delete'),
                          content: const Text(
                            'Are you sure you want to delete this entry?',
                          ),
                          actions: <Widget>[
                            TextButton(
                              child: const Text('Cancel'),
                              onPressed: () {
                                Navigator.of(dialogContext).pop();
                              },
                            ),
                            TextButton(
                              child: const Text('Delete'),
                              onPressed: () {
                                StoreProvider.of<AppState>(dialogContext)
                                    .dispatch(
                                        DeleteMoodDetailAction(widget.moodId));
                                Navigator.of(dialogContext).pop();
                                GoRouter.of(pageContext).pop();
                              },
                            ),
                          ],
                        );
                      },
                    );
                  }
                },
                itemBuilder: (BuildContext context) => <PopupMenuEntry<int>>[
                  const PopupMenuItem<int>(
                    value: 0,
                    child: Text('Edit'),
                  ),
                  const PopupMenuItem<int>(
                    value: 1,
                    child: Text('Delete'),
                  ),
                ],
              )
            ],
          ),
          backgroundColor: Colors.white,
          body: bodyContent,
        );
      },
    );
  }
}
