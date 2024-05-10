import 'package:isar/isar.dart';
import 'package:redux_saga/redux_saga.dart';
import 'package:teja/domain/entities/journal_entry_entity.dart';
import 'package:teja/domain/redux/journal/journal_editor/journal_editor_actions.video.dart';
import 'package:teja/infrastructure/database/isar_collections/journal_entry.dart';
import 'package:teja/infrastructure/repositories/journal_entry.video_entry_repository.dart';
import 'package:teja/infrastructure/repositories/journal_entry_repository.dart';

class VideoSaga {
  Iterable<void> saga() sync* {
    yield TakeEvery(_handleAddOrUpdateVideo, pattern: AddOrUpdateVideoAction);
    yield TakeEvery(_handleRemoveVideo, pattern: RemoveVideoAction);
    yield TakeEvery(_handleAddVideoToQuestionAnswerPair, pattern: AddVideoToQuestionAnswerPair);
    yield TakeEvery(_handleRemoveVideoFromQuestionAnswerPair, pattern: RemoveVideoFromQuestionAnswerPair);
    yield TakeEvery(_handleRefreshVideos, pattern: RefreshVideosAction);
  }

  _handleAddOrUpdateVideo({required AddOrUpdateVideoAction action}) sync* {
    var isarResult = Result<Isar>();
    yield GetContext('isar', result: isarResult);
    Isar isar = isarResult.value!;

    var journalEntryRepository = VideoEntryRepository(isar);

    yield Try(() sync* {
      yield Call(journalEntryRepository.addOrUpdateVideo, args: [action.journalEntryId, action.videoEntry]);
      yield Put(const AddOrUpdateVideoSuccessAction());
    }, Catch: (e, s) sync* {
      yield Put(AddOrUpdateVideoFailureAction(e.toString()));
    });
  }

  _handleRemoveVideo({required RemoveVideoAction action}) sync* {
    var isarResult = Result<Isar>();
    yield GetContext('isar', result: isarResult);
    Isar isar = isarResult.value!;

    var journalEntryRepository = VideoEntryRepository(isar);

    yield Try(() sync* {
      yield Call(journalEntryRepository.removeVideo, args: [action.journalEntryId, action.videoHash]);
      yield Put(const RemoveVideoSuccessAction());
    }, Catch: (e, s) sync* {
      yield Put(RemoveVideoFailureAction(e.toString()));
    });
  }

  _handleAddVideoToQuestionAnswerPair({required AddVideoToQuestionAnswerPair action}) sync* {
    var isarResult = Result<Isar>();
    yield GetContext('isar', result: isarResult);
    Isar isar = isarResult.value!;

    var journalEntryRepository = VideoEntryRepository(isar);

    yield Try(() sync* {
      // First, add or update the video in the repository
      yield Call(journalEntryRepository.addOrUpdateVideo, args: [action.journalEntryId, action.videoEntry]);

      // Then, link the video to the question-answer pair
      yield Call(journalEntryRepository.linkVideoToQuestionAnswerPair,
          args: [action.journalEntryId, action.questionAnswerPairId, action.videoEntry.id]);

      yield Put(const AddVideoToQuestionAnswerPairSuccessAction());

      // Refresh or reset videos logic after successful addition
      yield Put(RefreshVideosAction(action.journalEntryId));
    }, Catch: (e, s) sync* {
      yield Put(AddVideoToQuestionAnswerPairFailureAction(e.toString()));
    });
  }

  _handleRemoveVideoFromQuestionAnswerPair({required RemoveVideoFromQuestionAnswerPair action}) sync* {
    var isarResult = Result<Isar>();
    yield GetContext('isar', result: isarResult);
    Isar isar = isarResult.value!;

    var journalEntryRepository = VideoEntryRepository(isar);

    yield Try(() sync* {
      // First, unlink the video from the question-answer pair
      yield Call(journalEntryRepository.unlinkVideoFromQuestionAnswerPair,
          args: [action.journalEntryId, action.questionAnswerPairId, action.videoId]);

      // Then, remove the video from the repository
      yield Call(journalEntryRepository.removeVideo, args: [action.journalEntryId, action.videoId]);

      yield Put(const RemoveVideoFromQuestionAnswerPairSuccessAction());
    }, Catch: (e, s) sync* {
      yield Put(RemoveVideoFromQuestionAnswerPairFailureAction(e.toString()));
    });
  }

  _handleRefreshVideos({required RefreshVideosAction action}) sync* {
    var isarResult = Result<Isar>();
    yield GetContext('isar', result: isarResult);
    Isar isar = isarResult.value!;

    var journalEntryRepository = JournalEntryRepository(isar);

    yield Try(() sync* {
      // Fetch the updated journal entry with the new videos
      var journalEntryResult = Result<JournalEntry>();
      yield Call(journalEntryRepository.getJournalEntryById, args: [action.journalEntryId], result: journalEntryResult);

      if (journalEntryResult.value != null) {
        JournalEntry journalEntry = journalEntryResult.value!;
        // Convert the JournalEntry to JournalEntryEntity (or your specific entity model)
        JournalEntryEntity updatedEntry = journalEntryRepository.toEntity(journalEntry);
        // Dispatch an action to update the state with this new entry
        yield Put(UpdateJournalEntryWithVideos(updatedEntry));
      }
    }, Catch: (e, s) sync* {
      // Handle potential errors
    });
  }
}
