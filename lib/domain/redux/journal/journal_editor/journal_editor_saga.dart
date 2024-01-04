import 'package:redux_saga/redux_saga.dart';
import 'package:teja/domain/redux/journal/journal_editor/journal_editor_actions.dart';
import 'package:teja/infrastructure/database/isar_collections/journal_entry.dart';
import 'package:teja/infrastructure/repositories/journal_entry_repository.dart';
import 'package:isar/isar.dart';

class JournalEditorSaga {
  Iterable<void> saga() sync* {
    yield TakeEvery(_handleInitializeJournalEditor, pattern: InitializeJournalEditor);
    yield TakeEvery(_handleSaveJournalEntry, pattern: SaveJournalEntry);
    yield TakeEvery(_handleUpdateQuestionAnswer, pattern: UpdateQuestionAnswer);
  }

  _handleInitializeJournalEditor({required InitializeJournalEditor action}) sync* {
    var isarResult = Result<Isar>();
    yield GetContext('isar', result: isarResult);
    Isar isar = isarResult.value!;

    var journalEntryRepository = JournalEntryRepository(isar);

    var journalEntryResult = Result<JournalEntry>();
    yield Call(journalEntryRepository.getJournalEntryById, args: [action.journalEntryId], result: journalEntryResult);

    if (journalEntryResult.value != null) {
      JournalEntry journalEntry = journalEntryResult.value!;
      yield Put(InitializeJournalEditorSuccessAction(journalEntryRepository.toEntity(journalEntry)));
    } else {
      yield Put(const InitializeJournalEditorFailureAction("Journal entry not found."));
    }
  }

  _handleSaveJournalEntry({required SaveJournalEntry action}) sync* {
    var isarResult = Result<Isar>();
    yield GetContext('isar', result: isarResult);
    Isar isar = isarResult.value!;

    var journalEntryRepository = JournalEntryRepository(isar);

    JournalEntry journalEntry = JournalEntry()
      ..id = action.journalEntry.id
      ..templateId = action.journalEntry.templateId
      // ... other properties
      ..questions = action.journalEntry.questions
          ?.map((q) => QuestionAnswerPair()
            ..questionId = q.questionId
            ..questionText = q.questionText
            ..answerText = q.answerText)
          .toList();

    yield Try(() sync* {
      yield Call(journalEntryRepository.addOrUpdateJournalEntry, args: [journalEntry]);
      yield Put(JournalEntrySaved("Journal entry updated successfully."));
    }, Catch: (e, s) sync* {
      yield Put(JournalEntrySaveFailed(e.toString()));
    });
  }

  _handleUpdateQuestionAnswer({required UpdateQuestionAnswer action}) sync* {
    var isarResult = Result<Isar>();
    yield GetContext('isar', result: isarResult);
    Isar isar = isarResult.value!;

    var journalEntryRepository = JournalEntryRepository(isar);

    // Fetch the existing journal entry
    var journalEntryResult = Result<JournalEntry>();
    yield Call(journalEntryRepository.getJournalEntryById, args: [action.journalEntryId], result: journalEntryResult);

    if (journalEntryResult.value != null) {
      // Update the specific question-answer pair
      JournalEntry journalEntry = journalEntryResult.value!;
      journalEntry.questions?.firstWhere((q) => q.questionId == action.questionId).answerText = action.answerText;

      // Save the updated journal entry
      yield Try(() sync* {
        yield Call(journalEntryRepository.addOrUpdateJournalEntry, args: [journalEntry]);
        yield Put(UpdateQuestionAnswerSuccessAction(
            journalEntryId: action.journalEntryId, questionId: action.questionId, answerText: action.answerText));
      }, Catch: (e, s) sync* {
        yield Put(UpdateQuestionAnswerFailureAction(e.toString()));
      });
    } else {
      yield Put(const UpdateQuestionAnswerFailureAction("Journal entry not found."));
    }
  }
}
