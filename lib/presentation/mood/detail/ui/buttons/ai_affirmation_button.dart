import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:teja/domain/entities/mood_log.dart';
import 'package:teja/domain/redux/app_state.dart';
import 'package:teja/domain/redux/mood/ai_suggestion/ai_suggestion_actions.dart';
import 'package:teja/shared/common/button.dart';

class AIAffirmationButton extends StatelessWidget {
  final MoodLogEntity selectedMoodLog;

  const AIAffirmationButton({Key? key, required this.selectedMoodLog}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _AIAffirmationButtonViewModel>(
      converter: (store) => _AIAffirmationButtonViewModel.fromStore(store, selectedMoodLog),
      builder: (context, viewModel) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (viewModel.affirmation != null)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: MarkdownBody(
                  data: viewModel.affirmation!,
                ),
              )
            else ...[
              Button(
                text: "Fetch AI Affirmation",
                icon: Icons.lightbulb,
                onPressed: viewModel.getAffirmation,
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

class _AIAffirmationButtonViewModel {
  final String? affirmation;
  final bool isLoading;
  final String? errorMessage;
  final VoidCallback getAffirmation;

  _AIAffirmationButtonViewModel({
    required this.affirmation,
    required this.isLoading,
    required this.errorMessage,
    required this.getAffirmation,
  });

  static _AIAffirmationButtonViewModel fromStore(Store<AppState> store, MoodLogEntity selectedMoodLog) {
    final aiSuggestionState = store.state.aiSuggestionState;

    return _AIAffirmationButtonViewModel(
      affirmation: selectedMoodLog.ai?.affirmation,
      isLoading: aiSuggestionState.isLoading,
      errorMessage: aiSuggestionState.errorMessage,
      getAffirmation: () {
        store.dispatch(FetchAIAffirmationAction(selectedMoodLog));
      },
    );
  }
}
