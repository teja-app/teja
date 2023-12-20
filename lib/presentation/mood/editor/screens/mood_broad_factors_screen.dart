import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:teja/domain/entities/master_factor.dart';
import 'package:teja/domain/redux/app_state.dart';
import 'package:teja/domain/redux/mood/editor/mood_editor_actions.dart';
import 'package:teja/domain/redux/mood/master_factor/actions.dart';
import 'package:teja/shared/common/button.dart'; // Import your custom Button

class BroadFactorsScreen extends StatefulWidget {
  const BroadFactorsScreen({
    Key? key,
  }) : super(key: key);

  @override
  BroadFactorsScreenState createState() => BroadFactorsScreenState();
}

class BroadFactorsScreenState extends State<BroadFactorsScreen> {
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    return StoreConnector<AppState, BroadFactorsViewModel>(
      converter: (store) => BroadFactorsViewModel.fromStore(store),
      builder: (context, viewModel) {
        List<String> selectedSubcategories = viewModel.selectedBroadFactors ?? [];
        return Stack(
          children: [
            SingleChildScrollView(
              key: const Key("feelingPage"),
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Reason behind these feelings?',
                    style: textTheme.titleMedium,
                  ),
                  ...viewModel.factors.map((factor) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 20,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Text(factor.title, style: textTheme.headline6),
                        ),
                        Wrap(
                          spacing: 1.0,
                          children: factor.subcategories.map((subcategory) {
                            bool isSelected = selectedSubcategories.contains(subcategory.slug);
                            return Button(
                              text: subcategory.title,
                              icon: isSelected ? Icons.check : null,
                              onPressed: () => _updateFactorsAction(viewModel.moodLogId, subcategory.slug, !isSelected),
                              buttonType: isSelected ? ButtonType.primary : ButtonType.defaultButton,
                            );
                          }).toList(),
                        ),
                      ],
                    );
                  }).toList(),
                ],
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                color: colorScheme.background,
                padding: const EdgeInsets.all(10.0),
                child: Button(
                  text: "Next",
                  onPressed: () {
                    final store = StoreProvider.of<AppState>(context);
                    store.dispatch(ChangePageAction(viewModel.currentPageIndex + 1));
                  },
                  buttonType: ButtonType.primary,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _updateFactorsAction(String moodLogId, String factorSlug, bool isSelected) {
    Store<AppState> store = StoreProvider.of<AppState>(context);
    List<String> updatedFactors =
        List<String>.from(store.state.moodEditorState.currentMoodLog?.factors?.whereType<String>().toList() ?? []);
    if (isSelected) {
      updatedFactors.add(factorSlug);
    } else {
      updatedFactors.removeWhere((slug) => slug == factorSlug);
    }
    store.dispatch(UpdateBroadFactorsAction(
      moodLogId: moodLogId,
      factors: updatedFactors,
    ));
  }
}

class BroadFactorsViewModel {
  final String moodLogId;
  final bool isLoading;
  final List<MasterFactorEntity> factors;
  final List<String>? selectedBroadFactors;
  final Function() fetchFactors;
  final int moodRating;
  final int currentPageIndex;

  BroadFactorsViewModel({
    required this.moodLogId,
    required this.isLoading,
    required this.factors,
    required this.fetchFactors,
    required this.moodRating,
    required this.currentPageIndex,
    this.selectedBroadFactors,
  });

  static BroadFactorsViewModel fromStore(Store<AppState> store) {
    return BroadFactorsViewModel(
      moodLogId: store.state.moodEditorState.currentMoodLog!.id,
      moodRating: store.state.moodEditorState.currentMoodLog?.moodRating ?? 0,
      selectedBroadFactors: store.state.moodEditorState.currentMoodLog?.factors,
      currentPageIndex: store.state.moodEditorState.currentPageIndex,
      isLoading: store.state.masterFactorState.isLoading,
      factors: store.state.masterFactorState.masterFactors,
      fetchFactors: () => store.dispatch(FetchMasterFactorsActionFromCache()),
    );
  }
}
