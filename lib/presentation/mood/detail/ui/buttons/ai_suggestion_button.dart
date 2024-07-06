import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:teja/domain/redux/app_state.dart';
import 'package:teja/domain/redux/mood/ai_suggestion/ai_suggestion_actions.dart';
import 'package:teja/domain/redux/mood/detail/mood_detail_actions.dart';
import 'package:teja/shared/common/button.dart';

class AISuggestionButton extends StatelessWidget {
  final String moodId;

  const AISuggestionButton({Key? key, required this.moodId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _AISuggestionButtonViewModel>(
      converter: (store) => _AISuggestionButtonViewModel.fromStore(store),
      onInit: (store) => store.dispatch(LoadMoodDetailAction(moodId)),
      builder: (context, viewModel) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (viewModel.suggestions != null)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: MarkdownBody(
                  data: viewModel.suggestions!,
                ),
              )
            else ...[
              Button(
                text: "Fetch AI Suggestion",
                icon: Icons.favorite,
                onPressed: () => viewModel.getSuggestions(moodId),
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

  _AISuggestionButtonViewModel({
    required this.suggestions,
    required this.isLoading,
    required this.errorMessage,
    required this.getSuggestions,
  });

  static _AISuggestionButtonViewModel fromStore(Store<AppState> store) {
    final aiSuggestionState = store.state.aiSuggestionState;
    final selectedMoodLog = store.state.moodDetailPage.selectedMoodLog;

    return _AISuggestionButtonViewModel(
      suggestions: store.state.moodDetailPage.selectedMoodLog?.ai?.suggestion,
      isLoading: aiSuggestionState.isLoading,
      errorMessage: aiSuggestionState.errorMessage,
      getSuggestions: (moodId) {
        store.dispatch(FetchAISuggestionAction(selectedMoodLog!));
      },
    );
  }
}
