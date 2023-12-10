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
  const FactorsScreen({super.key});

  @override
  _FactorsScreenState createState() => _FactorsScreenState();
}

class _FactorsScreenState extends State<FactorsScreen> {
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return StoreConnector<AppState, FactorsViewModel>(
      converter: (store) => FactorsViewModel.fromStore(store),
      builder: (context, viewModel) {
        return ListView.builder(
          itemCount: viewModel.selectedFeelings?.length ?? 0,
          itemBuilder: (context, index) {
            FeelingEntity feeling = viewModel.selectedFeelings![index];
            // Filter out null values
            List<SubCategoryEntity> selectedSubcategories =
                viewModel.selectedFactorsForFeelings?[feeling.id]?.whereType<SubCategoryEntity>().toList() ?? [];
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Why are you ${feeling.feeling}?',
                    style: textTheme.titleMedium,
                  ),
                  ...viewModel.factors.map((factor) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Text(factor.title, style: textTheme.headline6),
                        ),
                        Wrap(
                          spacing: 8.0,
                          children: factor.subcategories.map((subcategory) {
                            bool isSelected = selectedSubcategories.contains(subcategory);
                            return Button(
                              text: subcategory.title,
                              icon: isSelected ? Icons.check : null,
                              onPressed: () =>
                                  _updateFactorsAction(viewModel.moodLogId, feeling.id!, subcategory, !isSelected),
                              buttonType: isSelected ? ButtonType.primary : ButtonType.defaultButton,
                            );
                          }).toList(),
                        ),
                      ],
                    );
                  }).toList(),
                ],
              ),
            );
          },
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
  final List<FeelingEntity>? selectedFeelings;
  final Map<int, List<SubCategoryEntity?>>? selectedFactorsForFeelings;
  final Function() fetchFactors;
  final int moodRating;

  FactorsViewModel({
    required this.moodLogId,
    required this.isLoading,
    required this.factors,
    required this.fetchFactors,
    required this.moodRating,
    this.selectedFeelings,
    this.selectedFactorsForFeelings, // Updated type
  });

  static FactorsViewModel fromStore(Store<AppState> store) {
    return FactorsViewModel(
      moodLogId: store.state.moodEditorState.currentMoodLog!.id,
      moodRating: store.state.moodEditorState.currentMoodLog?.moodRating ?? 0,
      selectedFactorsForFeelings: store.state.moodEditorState.selectedFactorsForFeelings,
      isLoading: store.state.masterFactorState.isLoading,
      factors: store.state.masterFactorState.masterFactors ?? [],
      fetchFactors: () => store.dispatch(FetchMasterFactorsActionFromCache()),
      selectedFeelings: store.state.moodEditorState.currentMoodLog?.feelings ?? [],
    );
  }
}
