import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:teja/domain/entities/mood_log.dart';
import 'package:teja/domain/redux/app_state.dart';
import 'package:teja/domain/redux/mood/ai_suggestion/ai_suggestion_actions.dart';
import 'package:teja/shared/common/button.dart';

class AITitleButton extends StatelessWidget {
  final MoodLogEntity selectedMoodLog;

  const AITitleButton({Key? key, required this.selectedMoodLog}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _AITitleButtonViewModel>(
      converter: (store) => _AITitleButtonViewModel.fromStore(store, selectedMoodLog),
      builder: (context, viewModel) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (viewModel.title == null) ...[
              Button(
                text: "Fetch AI Title",
                icon: Icons.title,
                onPressed: viewModel.getTitle,
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

class _AITitleButtonViewModel {
  final String? title;
  final bool isLoading;
  final String? errorMessage;
  final VoidCallback getTitle;

  _AITitleButtonViewModel({
    required this.title,
    required this.isLoading,
    required this.errorMessage,
    required this.getTitle,
  });

  static _AITitleButtonViewModel fromStore(Store<AppState> store, MoodLogEntity selectedMoodLog) {
    final aiSuggestionState = store.state.aiSuggestionState;

    return _AITitleButtonViewModel(
      title: selectedMoodLog.ai?.title,
      isLoading: aiSuggestionState.isLoading,
      errorMessage: aiSuggestionState.errorMessage,
      getTitle: () {
        store.dispatch(FetchAITitleAction(selectedMoodLog));
      },
    );
  }
}
