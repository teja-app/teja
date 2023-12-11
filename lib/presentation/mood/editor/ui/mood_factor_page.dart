import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:teja/domain/entities/feeling.dart';
import 'package:teja/domain/entities/master_factor.dart';
import 'package:teja/domain/redux/app_state.dart';
import 'package:teja/domain/redux/mood/editor/mood_editor_actions.dart';
import 'package:teja/domain/redux/mood/master_factor/actions.dart';
import 'package:teja/shared/common/button.dart'; // Import your custom Button

class FactorsScreen extends StatefulWidget {
  final FeelingEntity feeling;

  const FactorsScreen({Key? key, required this.feeling}) : super(key: key);

  @override
  _FactorsScreenState createState() => _FactorsScreenState();
}

class _FactorsScreenState extends State<FactorsScreen> {
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    return StoreConnector<AppState, FactorsViewModel>(
      converter: (store) => FactorsViewModel.fromStore(store, widget.feeling),
      builder: (context, viewModel) {
        List<SubCategoryEntity> selectedSubcategories =
            viewModel.selectedFactorsForFeelings?[widget.feeling.id]?.whereType<SubCategoryEntity>().toList() ?? [];
        return Stack(
          children: [
            SingleChildScrollView(
              key: const Key("feelingPage"),
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Why do you feel ${widget.feeling.feeling}?',
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
                            bool isSelected = selectedSubcategories.contains(subcategory);
                            return Button(
                              text: subcategory.title,
                              icon: isSelected ? Icons.check : null,
                              onPressed: () => _updateFactorsAction(
                                  viewModel.moodLogId, widget.feeling.id!, subcategory, !isSelected),
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

  void _updateFactorsAction(String moodLogId, int feelingId, SubCategoryEntity subcategory, bool isSelected) {
    Store<AppState> store = StoreProvider.of<AppState>(context);
    List<SubCategoryEntity> updatedSubcategories = List<SubCategoryEntity>.from(
        store.state.moodEditorState.selectedFactorsForFeelings?[feelingId]?.whereType<SubCategoryEntity>().toList() ??
            []);
    if (isSelected) {
      updatedSubcategories.add(subcategory);
    } else {
      updatedSubcategories.removeWhere((sc) => sc.slug == subcategory.slug);
    }
    store.dispatch(UpdateFactorsAction(
      moodLogId: moodLogId,
      feelingId: feelingId,
      factors: updatedSubcategories,
    ));
  }
}

class FactorsViewModel {
  final String moodLogId;
  final bool isLoading;
  final List<MasterFactorEntity> factors;
  final Map<int, List<SubCategoryEntity?>>? selectedFactorsForFeelings;
  final Function() fetchFactors;
  final int moodRating;
  final int currentPageIndex;

  FactorsViewModel({
    required this.moodLogId,
    required this.isLoading,
    required this.factors,
    required this.fetchFactors,
    required this.moodRating,
    required this.selectedFactorsForFeelings,
    required this.currentPageIndex,
  });

  static FactorsViewModel fromStore(Store<AppState> store, FeelingEntity feeling) {
    return FactorsViewModel(
      moodLogId: store.state.moodEditorState.currentMoodLog!.id,
      moodRating: store.state.moodEditorState.currentMoodLog?.moodRating ?? 0,
      currentPageIndex: store.state.moodEditorState.currentPageIndex,
      selectedFactorsForFeelings: store.state.moodEditorState.selectedFactorsForFeelings,
      isLoading: store.state.masterFactorState.isLoading,
      factors: store.state.masterFactorState.masterFactors,
      fetchFactors: () => store.dispatch(FetchMasterFactorsActionFromCache()),
    );
  }
}
