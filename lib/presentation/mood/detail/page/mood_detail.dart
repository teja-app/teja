import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:posthog_flutter/posthog_flutter.dart';
import 'package:redux/redux.dart';
import 'package:teja/domain/entities/master_factor.dart';
import 'package:teja/domain/redux/app_state.dart';
import 'package:teja/domain/redux/mood/ai_suggestion/ai_suggestion_actions.dart';
import 'package:teja/domain/redux/mood/detail/mood_detail_actions.dart';
import 'package:teja/domain/redux/mood/detail/mood_detail_state.dart';
import 'package:teja/domain/redux/mood/editor/mood_editor_actions.dart';
import 'package:teja/presentation/mood/detail/ui/buttons/ai_affirmation_button.dart';
import 'package:teja/presentation/mood/detail/ui/buttons/ai_suggestion_button.dart';
import 'package:teja/presentation/mood/detail/ui/buttons/ai_title_button.dart';
import 'package:teja/presentation/mood/ui/attachement_image.dart';
import 'package:teja/presentation/mood/detail/ui/feeling_list.dart';
import 'package:teja/presentation/mood/detail/ui/mood_rating_widget.dart';
import 'package:teja/presentation/mood/detail/ui/mood_setting_menu.dart';
import 'package:teja/presentation/navigation/isDesktop.dart';
import 'package:teja/router.dart';
import 'package:teja/shared/common/bento_box.dart';
import 'package:teja/shared/common/flexible_height_box.dart';

class MoodEntryWidget extends StatelessWidget {
  final DateTime timestamp;

  const MoodEntryWidget({
    Key? key,
    required this.timestamp,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Text(
      DateFormat('dd-MMM-yyyy, h:mm a').format(timestamp),
      style: textTheme.labelMedium,
      textAlign: TextAlign.center,
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
  MoodDetailPageState createState() => MoodDetailPageState();
}

class MoodDetailPageState extends State<MoodDetailPage> {
  late Store<AppState> store;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      store = StoreProvider.of<AppState>(context);
      store.dispatch(LoadMoodDetailAction(widget.moodId));
    });
  }

  void onEditMoodLog(String moodLogId) {
    final store = StoreProvider.of<AppState>(context);
    store.dispatch(InitializeMoodEditorAction(moodLogId));
    GoRouter.of(context).pushNamed(RootPath.moodEdit);
  }

  List<SubCategoryEntity> getFactors(
      List<MasterFactorEntity> masterFactors, List<String> factors) {
    return factors.map((slug) {
          return masterFactors
              .expand((factor) => factor.subcategories)
              .firstWhere(
                (subCategory) => subCategory.slug == slug,
                orElse: () => SubCategoryEntity(slug: slug, title: "Unknown"),
              );
        }).toList() ??
        [];
  }

  void onShareMoodLog(String moodLogId) {
    GoRouter.of(context).pushNamed(
      RootPath.moodShare,
      queryParameters: {
        "id": moodLogId,
      },
    );
  }

  @override
  void dispose() {
    store.dispatch(const ClearErrorMessagesAction());
    super.dispose();
  }

  @override
  Widget build(BuildContext pageContext) {
    Posthog posthog = Posthog();
    posthog.screen(
      screenName: 'Mood Detail Page',
    );
    final textTheme = Theme.of(context).textTheme;

    return StoreConnector<AppState, MoodDetailPageViewModel>(
      converter: (store) => MoodDetailPageViewModel.fromStore(store),
      builder: (context, viewModel) {
        MoodDetailState moodDetailPage = viewModel.moodDetailPage;
        Widget bodyContent = const Center(child: CircularProgressIndicator());
        if (moodDetailPage.selectedMoodLog != null) {
          final moodLog = moodDetailPage.selectedMoodLog;
          List<SubCategoryEntity> factors = [];
          if (moodDetailPage.selectedMoodLog?.factors != null &&
              moodDetailPage.selectedMoodLog!.factors!.isNotEmpty) {
            factors = getFactors(viewModel.masterFactors,
                moodDetailPage.selectedMoodLog!.factors!);
          }
          bodyContent = Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                BentoBox(
                  gridWidth: 4,
                  gridHeight: 1,
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
                    ],
                  ),
                ),
                if (moodLog?.attachments != null &&
                    moodLog!.attachments!.isNotEmpty)
                  BentoBox(
                    gridWidth: 4,
                    gridHeight: 1.3,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8.0), // Add some vertical padding
                      child: GridView.builder(
                        shrinkWrap: true,
                        physics:
                            const NeverScrollableScrollPhysics(), // to disable GridView's scrolling
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 4, // Adjust based on your design
                        ),
                        itemCount:
                            moodDetailPage.selectedMoodLog!.attachments!.length,
                        itemBuilder: (context, index) {
                          return AttachmentImage(
                            relativeImagePath: moodDetailPage
                                .selectedMoodLog!.attachments![index].path,
                          );
                        },
                      ),
                    ),
                  ),
                if (moodDetailPage.selectedMoodLog!.comment != null &&
                    moodDetailPage.selectedMoodLog!.comment!.isNotEmpty)
                  FlexibleHeightBox(
                    gridWidth: 4,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          moodDetailPage.selectedMoodLog!.comment!,
                        ),
                      ],
                    ),
                  ),
                if (factors.isNotEmpty)
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const SizedBox(height: 32),
                      Text(
                        'Factors',
                        style: textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      FlexibleHeightBox(
                        gridWidth: 4,
                        padding: 12,
                        child: Text(
                          factors
                              .map((subCategory) => subCategory.title)
                              .join(', '),
                          style: textTheme.titleSmall,
                        ),
                      ),
                    ],
                  ),

                if (moodDetailPage.selectedMoodLog!.feelings != null &&
                    moodDetailPage.selectedMoodLog!.feelings!.isNotEmpty)
                  FeelingsListWidget(
                      feelings: moodDetailPage.selectedMoodLog!.feelings!),
                const SizedBox(height: 16), // Add some spacing
                Text(
                  'Suggestion',
                  style: textTheme.titleMedium,
                ),
                FlexibleHeightBox(
                  gridWidth: 4,
                  child: AISuggestionButton(
                    moodId: viewModel.moodDetailPage.selectedMoodLog!.id,
                  ),
                ),
                Text(
                  'Affirmation',
                  style: textTheme.titleMedium,
                ),
                FlexibleHeightBox(
                  gridWidth: 4,
                  child: AIAffirmationButton(
                    selectedMoodLog: viewModel.moodDetailPage.selectedMoodLog!,
                  ),
                ),
                AITitleButton(
                  selectedMoodLog: viewModel.moodDetailPage.selectedMoodLog!,
                ),
                const SizedBox(height: 8),
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
            elevation: 0,
            title: moodDetailPage.selectedMoodLog?.ai?.title != null
                ? Text(moodDetailPage.selectedMoodLog?.ai?.title ?? "")
                : MoodEntryWidget(
                    timestamp: moodDetailPage.selectedMoodLog!.timestamp,
                  ),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                GoRouter.of(context).goNamed(RootPath.home);
              },
            ),
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
                onEdit: () {
                  onEditMoodLog(widget.moodId);
                },
                onShare: () {
                  onShareMoodLog(widget.moodId);
                },
              ),
            ],
          ),
          body: Align(
            alignment: Alignment
                .topCenter, // Aligns content to the top center of the page
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: isDesktop(context) ? 630 : double.infinity,
              ),
              child: SingleChildScrollView(
                child: bodyContent,
              ),
            ),
          ),
        );
      },
    );
  }
}

class MoodDetailPageViewModel {
  final MoodDetailState moodDetailPage;
  final List<MasterFactorEntity> masterFactors;

  MoodDetailPageViewModel({
    required this.moodDetailPage,
    required this.masterFactors,
  });

  static MoodDetailPageViewModel fromStore(Store<AppState> store) {
    return MoodDetailPageViewModel(
      moodDetailPage: store.state.moodDetailPage,
      masterFactors: store.state.masterFactorState.masterFactors,
    );
  }
}
