import 'package:isar/isar.dart';
import 'package:redux_saga/redux_saga.dart';
import 'package:teja/domain/redux/mood/ai_suggestion/ai_suggestion_actions.dart';
import 'package:teja/domain/redux/mood/detail/mood_detail_actions.dart';
import 'package:teja/infrastructure/api/mood_suggestion_api.dart';
import 'package:teja/infrastructure/repositories/mood_log_repository.dart';
import 'package:teja/shared/storage/secure_storage.dart';

class AISuggestionSaga {
  Iterable<void> saga() sync* {
    yield TakeEvery(_fetchAISuggestion, pattern: FetchAISuggestionAction);
  }

  _fetchAISuggestion({required FetchAISuggestionAction action}) sync* {
    var isarResult = Result<Isar>();
    yield GetContext('isar', result: isarResult);
    Isar isar = isarResult.value!;

    var moodLogRepository = MoodLogRepository(isar);
    yield Try(() sync* {
      final authTokenResult = Result<String?>();
      yield Call(SecureStorage().readAccessToken, result: authTokenResult);

      final authToken = authTokenResult.value;
      if (authToken == null) {
        yield Put(const FetchAISuggestionFailureAction('Authorization token not found'));
        return;
      }

      final moodData = {
        'moodDetail': (
          "Rating: ${action.moodLogEntity.moodRating}/5 \n"
              "Description: ${action.moodLogEntity.comment} \n"
              "Timestamp: ${action.moodLogEntity.timestamp} \n"
              "Factors: ${action.moodLogEntity.factors} \n"
              "Feelings: ${action.moodLogEntity.feelings?.map((f) => f.feeling).toList()} \n",
        ).toString(),
      };
      final response = Result();
      yield Call(MoodSuggestionAPI().fetchAISuggestions, args: [authToken, moodData], result: response);

      if (response.value.statusCode == 201) {
        if (response.value.data["success"] == false) {
          String failureMessage = "Failed to fetch suggestion for this. "
              "This can be due to various reasons: "
              "The response can be blocked because the input or response may contain descriptions of violence, sexual themes, or otherwise derogatory content.";
          yield Put(FetchAISuggestionFailureAction(failureMessage));
        } else {
          yield Put(FetchAISuggestionSuccessAction(action.moodLogEntity.id, response.value.data['suggestions']));
          yield Call(moodLogRepository.updateAISuggestion,
              args: [action.moodLogEntity.id, response.value.data['suggestions']]);
          yield Put(UpdateAISuggestionAction(action.moodLogEntity.id, response.value.data['suggestions']));
          yield Put(
            LoadMoodDetailAction(action.moodLogEntity.id),
          );
        }
      } else {
        print("response ${response.value}");
        yield Put(const FetchAISuggestionFailureAction('Failed to get suggestions'));
      }
    }, Catch: (e, s) sync* {
      yield Put(const FetchAISuggestionFailureAction('Failed to get suggestions'));
    });
  }
}
