import 'package:redux_saga/redux_saga.dart';
import 'package:teja/domain/entities/journal_template_entity.dart';
import 'package:teja/domain/redux/app_state.dart';
import 'package:teja/domain/redux/journal/detail/journal_detail_actions.dart';
import 'package:teja/domain/redux/journal/journal_editor/journal_editor_actions.dart';
import 'package:teja/domain/redux/journal/journal_logs/journal_logs_actions.dart';
import 'package:teja/domain/redux/journal/list/journal_list_actions.dart';
import 'package:teja/infrastructure/database/isar_collections/journal_entry.dart';
import 'package:teja/infrastructure/repositories/journal_entry_repository.dart';
import 'package:isar/isar.dart';
import 'package:teja/infrastructure/repositories/journal_template_repository.dart';
import 'package:teja/infrastructure/utils/helpers.dart';

class JournalEditorSaga {
  Iterable<void> saga() sync* {
    yield TakeEvery(_handleInitializeJournalEditor, pattern: InitializeJournalEditor);
    yield TakeEvery(_handleSaveJournalEntry, pattern: SaveJournalEntry);
    yield TakeEvery(_handleUpdateQuestionAnswer, pattern: UpdateQuestionAnswer);
    yield TakeEvery(_handleClearJournalFormAction, pattern: ClearJournalEditor);
  }

  _handleClearJournalFormAction({required ClearJournalEditor action}) sync* {
    // Select the current mood log ID from the app state
    var currentJournalEntry = Result<String?>();
    yield Select(
      selector: (AppState state) => state.journalEditorState.currentJournalEntry?.id,
      result: currentJournalEntry,
    );
    String? journalEntryId = currentJournalEntry.value;

    if (journalEntryId != null) {
      // If the mood log ID is present, dispatch the necessary actions
      yield Put(ResetJournalEntriesListAction());
      yield Put(LoadJournalDetailAction(journalEntryId));
      yield Put(const FetchJournalLogsAction());
      yield Put(LoadJournalEntriesListAction(0, 3000));
      yield Put(const ClearJournalEditorSuccess());
    } else {
      // Handle the scenario when the mood log ID is not present
      // Possibly dispatch other actions or handle state updates
      yield Put(ResetJournalEntriesListAction());
      yield Put(const FetchJournalLogsAction());
      yield Put(LoadJournalEntriesListAction(0, 3000));
      yield Put(const ClearJournalEditorSuccess());
    }
  }

  _handleInitializeJournalEditor({required InitializeJournalEditor action}) sync* {
    var isarResult = Result<Isar>();
    yield GetContext('isar', result: isarResult);
    Isar isar = isarResult.value!;

    var journalEntryRepository = JournalEntryRepository(isar);
    var journalTemplateRepository = JournalTemplateRepository(isar);
    yield Try(() sync* {
      if (action.journalEntryId != null) {
        // Existing entry found, convert it to entity and dispatch success action
        var journalEntryResult = Result<JournalEntry>();
        yield Call(journalEntryRepository.getJournalEntryById,
            args: [action.journalEntryId], result: journalEntryResult);
        JournalEntry journalEntry = journalEntryResult.value!;
        yield Put(InitializeJournalEditorSuccessAction(journalEntryRepository.toEntity(journalEntry)));
      } else if (action.template != null && action.template?.id != null) {
        // Fetch the journal template to get the questions
        var journalTemplateResult = Result<JournalTemplateEntity>();
        yield Call(journalTemplateRepository.getJournalTemplateById,
            args: [action.template!.templateID], result: journalTemplateResult);

        JournalTemplateEntity journalTemplate = journalTemplateResult.value!; // Handle null case as needed

        // Create a new entry with questions initialized from the template
        JournalEntry newJournalEntry = JournalEntry()
          ..id = Helpers.generateUniqueId()
          ..templateId = action.template!.id
          ..timestamp = DateTime.now()
          ..createdAt = DateTime.now()
          ..updatedAt = DateTime.now()
          ..questions = journalTemplate.questions
              .map((question) => QuestionAnswerPair()
                ..questionId = question.id
                ..questionText = question.text
                ..answerText = "")
              .toList();

        yield Call(journalEntryRepository.addOrUpdateJournalEntry, args: [newJournalEntry]);
        yield Put(InitializeJournalEditorSuccessAction(journalEntryRepository.toEntity(newJournalEntry)));
      }
    }, Catch: (e, s) sync* {
      yield Put(InitializeJournalEditorFailureAction(e.toString()));
    });
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
