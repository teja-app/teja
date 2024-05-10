import 'package:isar/isar.dart';
import 'package:redux_saga/redux_saga.dart';
import 'package:teja/domain/entities/journal_entry_entity.dart';
import 'package:teja/domain/redux/journal/journal_editor/journal_editor_actions.voice.dart';
import 'package:teja/infrastructure/database/isar_collections/journal_entry.dart';
import 'package:teja/infrastructure/repositories/journal_entry.voice_entry_repository.dart';
import 'package:teja/infrastructure/repositories/journal_entry_repository.dart';

class VoiceSaga {
  Iterable<void> saga() sync* {
    yield TakeEvery(_handleAddOrUpdateVoice, pattern: AddOrUpdateVoiceAction);
    yield TakeEvery(_handleRemoveVoice, pattern: RemoveVoiceAction);
    yield TakeEvery(_handleAddVoiceToQuestionAnswerPair, pattern: AddVoiceToQuestionAnswerPair);
    yield TakeEvery(_handleRemoveVoiceFromQuestionAnswerPair, pattern: RemoveVoiceFromQuestionAnswerPair);
    yield TakeEvery(_handleRefreshVoices, pattern: RefreshVoicesAction);
  }

  _handleAddOrUpdateVoice({required AddOrUpdateVoiceAction action}) sync* {
    var isarResult = Result<Isar>();
    yield GetContext('isar', result: isarResult);
    Isar isar = isarResult.value!;

    var journalEntryRepository = VoiceEntryRepository(isar);

    yield Try(() sync* {
      yield Call(journalEntryRepository.addOrUpdateVoice, args: [action.journalEntryId, action.voiceEntry]);
      yield Put(const AddOrUpdateVoiceSuccessAction());
    }, Catch: (e, s) sync* {
      yield Put(AddOrUpdateVoiceFailureAction(e.toString()));
    });
  }

  _handleRemoveVoice({required RemoveVoiceAction action}) sync* {
    var isarResult = Result<Isar>();
    yield GetContext('isar', result: isarResult);
    Isar isar = isarResult.value!;

    var journalEntryRepository = VoiceEntryRepository(isar);

    yield Try(() sync* {
      yield Call(journalEntryRepository.removeVoice, args: [action.journalEntryId, action.voiceHash]);
      yield Put(const RemoveVoiceSuccessAction());
    }, Catch: (e, s) sync* {
      yield Put(RemoveVoiceFailureAction(e.toString()));
    });
  }

  _handleAddVoiceToQuestionAnswerPair({required AddVoiceToQuestionAnswerPair action}) sync* {
    var isarResult = Result<Isar>();
    yield GetContext('isar', result: isarResult);
    Isar isar = isarResult.value!;

    var journalEntryRepository = VoiceEntryRepository(isar);

    yield Try(() sync* {
      // First, add or update the voice in the repository
      yield Call(journalEntryRepository.addOrUpdateVoice, args: [action.journalEntryId, action.voiceEntry]);

      // Then, link the voice to the question-answer pair
      yield Call(journalEntryRepository.linkVoiceToQuestionAnswerPair,
          args: [action.journalEntryId, action.questionAnswerPairId, action.voiceEntry.id]);

      yield Put(const AddVoiceToQuestionAnswerPairSuccessAction());

      // Refresh or reset voices logic after successful addition
      yield Put(RefreshVoicesAction(action.journalEntryId));
    }, Catch: (e, s) sync* {
      yield Put(AddVoiceToQuestionAnswerPairFailureAction(e.toString()));
    });
  }

  _handleRemoveVoiceFromQuestionAnswerPair({required RemoveVoiceFromQuestionAnswerPair action}) sync* {
    var isarResult = Result<Isar>();
    yield GetContext('isar', result: isarResult);
    Isar isar = isarResult.value!;

    var journalEntryRepository = VoiceEntryRepository(isar);

    yield Try(() sync* {
      // First, unlink the voice from the question-answer pair
      yield Call(journalEntryRepository.unlinkVoiceFromQuestionAnswerPair,
          args: [action.journalEntryId, action.questionAnswerPairId, action.voiceId]);

      // Then, remove the voice from the repository
      yield Call(journalEntryRepository.removeVoice, args: [action.journalEntryId, action.voiceId]);

      yield Put(const RemoveVoiceFromQuestionAnswerPairSuccessAction());
    }, Catch: (e, s) sync* {
      yield Put(RemoveVoiceFromQuestionAnswerPairFailureAction(e.toString()));
    });
  }

  _handleRefreshVoices({required RefreshVoicesAction action}) sync* {
    var isarResult = Result<Isar>();
    yield GetContext('isar', result: isarResult);
    Isar isar = isarResult.value!;

    var journalEntryRepository = JournalEntryRepository(isar);

    yield Try(() sync* {
      // Fetch the updated journal entry with the new voices
      var journalEntryResult = Result<JournalEntry>();
      yield Call(journalEntryRepository.getJournalEntryById, args: [action.journalEntryId], result: journalEntryResult);

      if (journalEntryResult.value != null) {
        JournalEntry journalEntry = journalEntryResult.value!;
        // Convert the JournalEntry to JournalEntryEntity (or your specific entity model)
        JournalEntryEntity updatedEntry = journalEntryRepository.toEntity(journalEntry);
        // Dispatch an action to update the state with this new entry
        yield Put(UpdateJournalEntryWithVoices(updatedEntry));
      }
    }, Catch: (e, s) sync* {
      // Handle potential errors
    });
  }
}
