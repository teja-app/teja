import 'package:isar/isar.dart';
import 'package:redux_saga/redux_saga.dart';
import 'package:teja/domain/entities/journal_entry_entity.dart';
import 'package:teja/domain/redux/journal/journal_editor/journal_editor_actions.image.dart';
import 'package:teja/infrastructure/database/isar_collections/journal_entry.dart';
import 'package:teja/infrastructure/repositories/journal_entry.image_entry_repository.dart';
import 'package:teja/infrastructure/repositories/journal_entry_repository.dart';

class ImageSaga {
  Iterable<void> saga() sync* {
    yield TakeEvery(_handleAddOrUpdateImage, pattern: AddOrUpdateImageAction);
    yield TakeEvery(_handleRemoveImage, pattern: RemoveImageAction);
    yield TakeEvery(_handleAddImageToQuestionAnswerPair, pattern: AddImageToQuestionAnswerPair);
    yield TakeEvery(_handleRemoveImageFromQuestionAnswerPair, pattern: RemoveImageFromQuestionAnswerPair);
    yield TakeEvery(_handleRefreshImages, pattern: RefreshImagesAction);
  }

  _handleAddOrUpdateImage({required AddOrUpdateImageAction action}) sync* {
    var isarResult = Result<Isar>();
    yield GetContext('isar', result: isarResult);
    Isar isar = isarResult.value!;

    var journalEntryRepository = ImageEntryRepository(isar);

    yield Try(() sync* {
      yield Call(journalEntryRepository.addOrUpdateImage, args: [action.journalEntryId, action.imageEntry]);
      yield Put(const AddOrUpdateImageSuccessAction());
    }, Catch: (e, s) sync* {
      yield Put(AddOrUpdateImageFailureAction(e.toString()));
    });
  }

  _handleRemoveImage({required RemoveImageAction action}) sync* {
    var isarResult = Result<Isar>();
    yield GetContext('isar', result: isarResult);
    Isar isar = isarResult.value!;

    var journalEntryRepository = ImageEntryRepository(isar);

    yield Try(() sync* {
      yield Call(journalEntryRepository.removeImage, args: [action.journalEntryId, action.imageHash]);
      yield Put(const RemoveImageSuccessAction());
    }, Catch: (e, s) sync* {
      yield Put(RemoveImageFailureAction(e.toString()));
    });
  }

  _handleAddImageToQuestionAnswerPair({required AddImageToQuestionAnswerPair action}) sync* {
    var isarResult = Result<Isar>();
    yield GetContext('isar', result: isarResult);
    Isar isar = isarResult.value!;

    var journalEntryRepository = ImageEntryRepository(isar);

    yield Try(() sync* {
      // First, add or update the image in the repository
      yield Call(journalEntryRepository.addOrUpdateImage, args: [action.journalEntryId, action.imageEntry]);

      // Then, link the image to the question-answer pair
      yield Call(journalEntryRepository.linkImageToQuestionAnswerPair,
          args: [action.journalEntryId, action.questionAnswerPairId, action.imageEntry.id]);

      yield Put(const AddImageToQuestionAnswerPairSuccessAction());

      // Refresh or reset images logic after successful addition
      yield Put(RefreshImagesAction(action.journalEntryId));
    }, Catch: (e, s) sync* {
      yield Put(AddImageToQuestionAnswerPairFailureAction(e.toString()));
    });
  }

  _handleRemoveImageFromQuestionAnswerPair({required RemoveImageFromQuestionAnswerPair action}) sync* {
    var isarResult = Result<Isar>();
    yield GetContext('isar', result: isarResult);
    Isar isar = isarResult.value!;

    var journalEntryRepository = ImageEntryRepository(isar);

    yield Try(() sync* {
      // First, unlink the image from the question-answer pair
      yield Call(journalEntryRepository.unlinkImageFromQuestionAnswerPair,
          args: [action.journalEntryId, action.questionAnswerPairId, action.imageId]);

      // Then, remove the image from the repository
      yield Call(journalEntryRepository.removeImage, args: [action.journalEntryId, action.imageId]);

      yield Put(const RemoveImageFromQuestionAnswerPairSuccessAction());
    }, Catch: (e, s) sync* {
      yield Put(RemoveImageFromQuestionAnswerPairFailureAction(e.toString()));
    });
  }

  _handleRefreshImages({required RefreshImagesAction action}) sync* {
    var isarResult = Result<Isar>();
    yield GetContext('isar', result: isarResult);
    Isar isar = isarResult.value!;

    var journalEntryRepository = JournalEntryRepository(isar);

    yield Try(() sync* {
      // Fetch the updated journal entry with the new images
      var journalEntryResult = Result<JournalEntry>();
      yield Call(journalEntryRepository.getJournalEntryById, args: [action.journalEntryId], result: journalEntryResult);

      if (journalEntryResult.value != null) {
        JournalEntry journalEntry = journalEntryResult.value!;
        // Convert the JournalEntry to JournalEntryEntity (or your specific entity model)
        JournalEntryEntity updatedEntry = journalEntryRepository.toEntity(journalEntry);
        // Dispatch an action to update the state with this new entry
        yield Put(UpdateJournalEntryWithImages(updatedEntry));
      }
    }, Catch: (e, s) sync* {
      // Handle potential errors
    });
  }
}
