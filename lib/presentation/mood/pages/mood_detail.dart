import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:icons_flutter/icons_flutter.dart';
import 'package:intl/intl.dart';
import 'package:redux/redux.dart';
import 'package:swayam/domain/entities/feeling.dart';
import 'package:swayam/domain/redux/app_state.dart';
import 'package:swayam/domain/redux/mood/detail/mood_detail_actions.dart';
import 'package:swayam/domain/redux/mood/detail/mood_detail_state.dart';
import 'package:swayam/shared/common/bento_box.dart';

class MoodEntryWidget extends StatelessWidget {
  final DateTime timestamp;

  const MoodEntryWidget({
    Key? key,
    required this.timestamp,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      DateFormat('dd-MMM-yyyy, h:mm a').format(timestamp),
      style: const TextStyle(
        color: Colors.black54,
        fontSize: 14, // Slightly smaller font for the timestamp
      ),
    );
  }
}

class MoodRatingWidget extends StatelessWidget {
  final int moodRating;

  const MoodRatingWidget({
    Key? key,
    required this.moodRating,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Determine the icon based on the mood rating
    String moodIconPath =
        'assets/icons/mood_${moodRating}_inactive.svg'; // Adjust the path as necessary

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Mood',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '$moodRating/5',
              style: const TextStyle(
                color: Colors.black,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        // Replace with SvgPicture.asset if using SVG icons
        SvgPicture.asset(
          moodIconPath,
          width: 40,
          height: 40,
        ), // Ensure you have the correct path and file for the asset
      ],
    );
  }
}

class FeelingsListWidget extends StatelessWidget {
  final List<FeelingEntity> feelings;

  const FeelingsListWidget({
    Key? key,
    required this.feelings,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Feelings',
          style: TextStyle(color: Colors.grey, fontSize: 22),
        ),
        const SizedBox(height: 8),
        ...feelings.map(
          (feeling) => BentoBox(
            gridWidth: 4,
            gridHeight: 1,
            child: Text(feeling.feeling),
          ),
        ),
      ],
    );
  }
}

class SettingsPopupMenu extends StatelessWidget {
  final String moodId;
  final Function onDelete;

  const SettingsPopupMenu({
    Key? key,
    required this.moodId,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<int>(
      key: const Key("mood_settings"),
      icon: const Icon(
        AntDesign.ellipsis1,
        color: Colors.black,
        size: 16,
      ),
      onSelected: (int result) {
        if (result == 0) {
          // Handle edit action
        } else if (result == 1) {
          onDelete();
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
    );
  }
}

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
                BentoBox(
                  gridWidth: 4,
                  gridHeight: 2,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 8.0), // Add some vertical padding
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment
                          .center, // Center the content vertically
                      crossAxisAlignment: CrossAxisAlignment
                          .start, // Align content to start horizontally
                      children: [
                        MoodRatingWidget(
                          moodRating:
                              moodDetailPage.selectedMoodLog?.moodRating ?? 0,
                        ),
                        const SizedBox(height: 8),
                        MoodEntryWidget(
                          timestamp: moodDetailPage.selectedMoodLog!.timestamp,
                        ),
                      ],
                    ),
                  ),
                ),
                if (moodDetailPage.selectedMoodLog!.feelings != null &&
                    moodDetailPage.selectedMoodLog!.feelings!.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 24.0),
                    child: FeelingsListWidget(
                        feelings: moodDetailPage.selectedMoodLog!.feelings!),
                  ),
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
            backgroundColor: Colors.grey.shade100,
            elevation: 0,
            iconTheme: const IconThemeData(color: Colors.black),
            title: const Text("mood entry"),
            actions: [
              SettingsPopupMenu(
                moodId: widget.moodId,
                onDelete: () {
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
                },
              ),
            ],
          ),
          backgroundColor: Colors.grey.shade100,
          body: bodyContent,
        );
      },
    );
  }
}
