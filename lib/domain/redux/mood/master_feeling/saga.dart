// lib/domain/redux/mood/master_feeling/saga.dart
import 'package:redux_saga/redux_saga.dart';
import 'package:swayam/domain/entities/master_feeling.dart';
import 'package:swayam/domain/redux/mood/master_feeling/actions.dart';
import 'package:swayam/infrastructure/api/mood_api.dart';
import 'package:swayam/shared/storage/secure_storage.dart';

// Main saga for master feelings
Iterable<void> masterFeelingSaga() sync* {
  yield TakeEvery(_fetchMasterFeelings, pattern: FetchMasterFeelingsAction);
}

// Saga to handle fetching master feelings
_fetchMasterFeelings({dynamic action}) sync* {
  try {
    yield Put(FetchMasterFeelingsInProgressAction());

    // Fetch the access token
    final accessToken = Result<String?>();
    yield Call(storage.read, args: ['access_token'], result: accessToken);

    MoodApi moodApi = MoodApi();
    var feelings = Result<List<MasterFeeling>>();
    yield Call(moodApi.getMasterFeelings,
        args: [accessToken.value], result: feelings);

    if (feelings.value != null) {
      yield Put(MasterFeelingsFetchedAction(feelings.value!));
    } else {
      // Handle the null case, perhaps by dispatching an error action
      yield Put(MasterFeelingsFetchFailedAction('No feelings data received'));
    }
  } catch (e) {
    yield Put(MasterFeelingsFetchFailedAction(e.toString()));
  }
}
