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
    yield TakeEvery(_fetchAITitle, pattern: FetchAITitleAction);
    yield TakeEvery(_fetchAIAffirmation, pattern: FetchAIAffirmationAction);
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

      final moodData = MoodData(
        moodId: action.moodLogEntity.id,
        moodDetail: (
          "Rating: ${action.moodLogEntity.moodRating}/5 \n"
              "Description: ${action.moodLogEntity.comment} \n"
              "Timestamp: ${action.moodLogEntity.timestamp} \n"
              "Factors: ${action.moodLogEntity.factors} \n"
              "Feelings: ${action.moodLogEntity.feelings?.map((f) => f.feeling).toList()} \n",
        ).toString(),
      );
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

  _fetchAITitle({required FetchAITitleAction action}) sync* {
    var isarResult = Result<Isar>();
    yield GetContext('isar', result: isarResult);
    Isar isar = isarResult.value!;

    var moodLogRepository = MoodLogRepository(isar);
    yield Try(() sync* {
      final authTokenResult = Result<String?>();
      yield Call(SecureStorage().readAccessToken, result: authTokenResult);

      final authToken = authTokenResult.value;
      if (authToken == null) {
        yield Put(const FetchAITitleFailureAction('Authorization token not found'));
        return;
      }

      final moodData = MoodData(
        moodId: action.moodLogEntity.id,
        moodDetail: (
          "Rating: ${action.moodLogEntity.moodRating}/5 \n"
              "Description: ${action.moodLogEntity.comment} \n"
              "Timestamp: ${action.moodLogEntity.timestamp} \n"
              "Factors: ${action.moodLogEntity.factors} \n"
              "Feelings: ${action.moodLogEntity.feelings?.map((f) => f.feeling).toList()} \n",
        ).toString(),
      );
      final response = Result();
      yield Call(MoodSuggestionAPI().fetchAITitle, args: [authToken, moodData], result: response);
      if (response.value.statusCode == 201) {
        if (response.value.data["success"] == false) {
          String failureMessage = "Failed to fetch title for this. "
              "This can be due to various reasons: "
              "The response can be blocked because the input or response may contain descriptions of violence, sexual themes, or otherwise derogatory content.";
          yield Put(FetchAITitleFailureAction(failureMessage));
        } else {
          yield Put(FetchAITitleSuccessAction(action.moodLogEntity.id, response.value.data['title']));
          yield Call(moodLogRepository.updateAITitle, args: [action.moodLogEntity.id, response.value.data['title']]);
          yield Put(UpdateAITitleAction(action.moodLogEntity.id, response.value.data['title']));
          yield Put(
            LoadMoodDetailAction(action.moodLogEntity.id),
          );
        }
      } else {
        print("response ${response.value}");
        yield Put(const FetchAITitleFailureAction('Failed to get title'));
      }
    }, Catch: (e, s) sync* {
      print("response ${e} ${s}");
      yield Put(const FetchAITitleFailureAction('Failed to get title'));
    });
  }

  _fetchAIAffirmation({required FetchAIAffirmationAction action}) sync* {
    var isarResult = Result<Isar>();
    yield GetContext('isar', result: isarResult);
    Isar isar = isarResult.value!;

    var moodLogRepository = MoodLogRepository(isar);
    yield Try(() sync* {
      final authTokenResult = Result<String?>();
      yield Call(SecureStorage().readAccessToken, result: authTokenResult);

      final authToken = authTokenResult.value;
      if (authToken == null) {
        yield Put(const FetchAIAffirmationFailureAction('Authorization token not found'));
        return;
      }

      final moodData = MoodData(
        moodId: action.moodLogEntity.id,
        moodDetail: (
          "Rating: ${action.moodLogEntity.moodRating}/5 \n"
              "Description: ${action.moodLogEntity.comment} \n"
              "Timestamp: ${action.moodLogEntity.timestamp} \n"
              "Factors: ${action.moodLogEntity.factors} \n"
              "Feelings: ${action.moodLogEntity.feelings?.map((f) => f.feeling).toList()} \n",
        ).toString(),
      );
      final response = Result();
      yield Call(MoodSuggestionAPI().fetchAIAffirmations, args: [authToken, moodData], result: response);

      print("response ${response}");

      if (response.value.statusCode == 201) {
        if (response.value.data["success"] == false) {
          String failureMessage = "Failed to fetch affirmations for this. "
              "This can be due to various reasons: "
              "The response can be blocked because the input or response may contain descriptions of violence, sexual themes, or otherwise derogatory content.";
          yield Put(FetchAIAffirmationFailureAction(failureMessage));
        } else {
          print("Inside Success");
          yield Put(FetchAIAffirmationSuccessAction(action.moodLogEntity.id, response.value.data['affirmations']));
          yield Call(moodLogRepository.updateAIAffirmation,
              args: [action.moodLogEntity.id, response.value.data['affirmations']]);
          print("Inside Success");
          yield Put(UpdateAIAffirmationAction(action.moodLogEntity.id, response.value.data['affirmations']));
          yield Put(
            LoadMoodDetailAction(
              action.moodLogEntity.id,
            ),
          );
        }
      } else {
        print("response ${response.value}");
        yield Put(const FetchAIAffirmationFailureAction('Failed to get affirmations'));
      }
    }, Catch: (e, s) sync* {
      print("response ${e} ${s}");
      yield Put(const FetchAIAffirmationFailureAction('Failed to get affirmations'));
    });
  }
}
