import 'package:redux_saga/redux_saga.dart';
import 'package:teja/domain/entities/journal_template_entity.dart';
import 'package:teja/domain/redux/app_state.dart';
import 'package:teja/domain/redux/journal/detail/journal_detail_actions.dart';
import 'package:teja/domain/redux/journal/journal_editor/journal_editor_actions.dart';
import 'package:teja/domain/redux/journal/journal_editor/journal_editor_saga.image_saga.dart';
import 'package:teja/domain/redux/journal/journal_editor/journal_editor_saga.video_saga.dart';
import 'package:teja/domain/redux/journal/journal_editor/journal_editor_saga.voice_saga.dart';
import 'package:teja/domain/redux/journal/journal_editor/quick_journal_editor_saga.dart';
import 'package:teja/domain/redux/journal/journal_logs/journal_logs_actions.dart';
import 'package:teja/domain/redux/journal/list/journal_list_actions.dart';
import 'package:teja/infrastructure/database/isar_collections/journal_entry.dart';
import 'package:teja/infrastructure/repositories/journal_entry_repository.dart';
import 'package:isar/isar.dart';
import 'package:teja/infrastructure/repositories/journal_template_repository.dart';
import 'package:teja/infrastructure/utils/helpers.dart';
import 'package:teja/shared/helpers/logger.dart';

class JournalEditorSaga {
  Iterable<void> saga() sync* {
    yield TakeEvery(_handleInitializeJournalEditor, pattern: InitializeJournalEditor);
    yield TakeEvery(_handleSaveJournalEntry, pattern: SaveJournalEntry);
    yield TakeEvery(_handleUpdateQuestionAnswer, pattern: UpdateQuestionAnswer);
    yield TakeEvery(_handleClearJournalFormAction, pattern: ClearJournalEditor);
    yield* ImageSaga().saga();
    yield* VideoSaga().saga();
    yield* VoiceSaga().saga();
    yield* QuickJournalEditorSaga().saga();
  }

  _handleClearJournalFormAction({required ClearJournalEditor action}) sync* {
    // Select the current mood log ID from the app state
    yield Try(() sync* {
      var currentJournalIdResult = Result<String?>();
      yield Select(
        selector: (AppState state) => state.journalEditorState.currentJournalEntry?.id,
        result: currentJournalIdResult,
      );
      String? journalEntryId = currentJournalIdResult.value;

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
    }, Catch: (e, s) sync* {
      yield Put(const ClearJournalEditorFailure());
    });
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
          ..timestamp = action.timestamp ?? DateTime.now()
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

    yield Try(() sync* {
      // Fetch the existing journal entry if it exists
      var journalEntryResult = Result<JournalEntry?>();
      yield Call(journalEntryRepository.getJournalEntryById,
          args: [action.journalEntry.id], result: journalEntryResult);
      JournalEntry? existingEntry = journalEntryResult.value;

      // Create or update the journal entry
      JournalEntry journalEntry = existingEntry ?? JournalEntry();
      journalEntry
        ..updatedAt = DateTime.now()
        ..questions = action.journalEntry.questions
            ?.map((q) => QuestionAnswerPair()
              ..questionId = q.questionId
              ..questionText = q.questionText
              ..answerText = q.answerText)
            .toList()
        ..textEntries = action.journalEntry.textEntries
            ?.map((t) => TextEntry()
              ..id = t.id
              ..content = t.content)
            .toList()
        ..voiceEntries = action.journalEntry.voiceEntries
            ?.map((v) => VoiceEntry()
              ..id = v.id
              ..filePath = v.filePath
              ..duration = v.duration
              ..hash = v.hash)
            .toList()
        ..videoEntries = action.journalEntry.videoEntries
            ?.map((v) => VideoEntry()
              ..id = v.id
              ..filePath = v.filePath
              ..duration = v.duration
              ..hash = v.hash)
            .toList()
        ..imageEntries = action.journalEntry.imageEntries
            ?.map((i) => ImageEntry()
              ..id = i.id
              ..filePath = i.filePath
              ..caption = i.caption
              ..hash = i.hash)
            .toList()
        ..bulletPointEntries = action.journalEntry.bulletPointEntries
            ?.map((b) => BulletPointEntry()
              ..id = b.id
              ..points = b.points)
            .toList()
        ..painNoteEntries = action.journalEntry.painNoteEntries
            ?.map((p) => PainNoteEntry()
              ..id = p.id
              ..painLevel = p.painLevel
              ..notes = p.notes)
            .toList()
        ..metadata = action.journalEntry.metadata != null
            ? (JournalEntryMetadata()..tags = action.journalEntry.metadata!.tags)
            : null
        ..lock = action.journalEntry.lock
        ..title = action.journalEntry.title
        ..body = action.journalEntry.body;
      yield Call(journalEntryRepository.addOrUpdateJournalEntry, args: [journalEntry]);
      yield Put(JournalEntrySaved("Journal entry saved successfully."));
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
      // Save the updated journal entry
      yield Try(() sync* {
        // Get the existing journal entry
        JournalEntry journalEntry = journalEntryResult.value!;

        // Convert the fixed-length list to a growable list
        var questions = List<QuestionAnswerPair>.from(journalEntry.questions ?? []);

        // Check if the question exists
        var question = questions.firstWhere(
          (q) => q.questionId == action.questionId,
          orElse: () => QuestionAnswerPair()
            ..questionId = action.questionId
            ..questionText = action.questionText,
        );

        // If the question didn't exist, add it to the questions list
        if (!questions.contains(question)) {
          questions.add(question);
        }

        // Update the specific question-answer pair
        question.answerText = action.answerText;

        // Update the journal entry with the new list of questions
        journalEntry.questions = questions;

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
