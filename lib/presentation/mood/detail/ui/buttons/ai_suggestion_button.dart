import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:teja/domain/redux/app_state.dart';
import 'package:teja/domain/redux/mood/detail/mood_detail_actions.dart';
import 'package:teja/domain/redux/mood/mood_analysis/mood_analysis_actions.dart';
import 'package:teja/domain/redux/permission/permissions_constants.dart';
import 'package:teja/presentation/onboarding/widgets/feature_gate.dart';
import 'package:teja/shared/common/button.dart';

class AISuggestionButton extends StatelessWidget {
  final String moodId;

  const AISuggestionButton({Key? key, required this.moodId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _AISuggestionButtonViewModel>(
      converter: (store) => _AISuggestionButtonViewModel.fromStore(store, moodId),
      onInit: (store) => store.dispatch(LoadMoodDetailAction(moodId)),
      builder: (context, viewModel) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (viewModel.suggestions != null && viewModel.currentMoodId == moodId)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: MarkdownBody(
                  data: viewModel.suggestions!,
                ),
              )
            else ...[
              FeatureGate(
                feature: AI_SUGGESTIONS,
                autoTriggerOnAccess: true,
                onFeatureAccessed: () => viewModel.getSuggestions(moodId),
                child: const Button(
                  text: "Fetch AI Suggestion",
                  icon: Icons.favorite,
                  // onPressed: () => viewModel.getSuggestions(moodId),
                ),
              ),
              if (viewModel.isLoading) const Center(child: CircularProgressIndicator()),
              if (viewModel.errorMessage != null)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(
                    viewModel.errorMessage!,
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
            ]
          ],
        );
      },
    );
  }
}

class _AISuggestionButtonViewModel {
  final String? suggestions;
  final bool isLoading;
  final String? errorMessage;
  final Function(String) getSuggestions;
  final String currentMoodId;

  _AISuggestionButtonViewModel({
    required this.suggestions,
    required this.isLoading,
    required this.errorMessage,
    required this.getSuggestions,
    required this.currentMoodId,
  });

  static _AISuggestionButtonViewModel fromStore(Store<AppState> store, String moodId) {
    final aiSuggestionState = store.state.moodAnalysisState;
    final selectedMoodLog = store.state.moodDetailPage.selectedMoodLog;

    return _AISuggestionButtonViewModel(
      suggestions: selectedMoodLog?.id == moodId ? selectedMoodLog?.ai?.suggestion : null,
      isLoading: aiSuggestionState.isAnalyzing,
      errorMessage: aiSuggestionState.errorMessage,
      getSuggestions: (moodId) {
        store.dispatch(AnalyzeMoodAction(selectedMoodLog!.id));
      },
      currentMoodId: moodId,
    );
  }
}
