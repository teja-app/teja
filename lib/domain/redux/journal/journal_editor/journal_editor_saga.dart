import 'package:redux_saga/redux_saga.dart' as redux_saga;
import 'package:redux_saga/redux_saga.dart' hide Result, Select;
import 'package:teja/domain/entities/journal_template_entity.dart';
import 'package:teja/domain/redux/app_state.dart';
import 'package:teja/domain/redux/journal/detail/journal_detail_actions.dart';
import 'package:teja/domain/redux/journal/journal_editor/journal_editor_actions.dart';
import 'package:teja/domain/redux/journal/journal_editor/journal_editor_saga.image_saga.dart';
import 'package:teja/domain/redux/journal/journal_editor/journal_editor_saga.video_saga.dart';
import 'package:teja/domain/redux/journal/journal_editor/journal_editor_saga.voice_saga.dart';
import 'package:teja/domain/redux/journal/journal_editor/quick_journal_editor_saga.dart';
import 'package:teja/domain/redux/journal/journal_logs/journal_logs_actions.dart';
import 'package:teja/domain/redux/journal/journal_sync/journal_sync_actions.dart';
import 'package:teja/domain/redux/journal/list/journal_list_actions.dart';
import 'package:teja/infrastructure/repositories/journal_entry_repository.dart';
import 'package:teja/infrastructure/repositories/journal_template_repository.dart';
import 'package:teja/infrastructure/utils/helpers.dart';
import 'package:cbl/cbl.dart' as cbl;
import 'package:teja/infrastructure/database/cbl_collections/journal_entry.dart' as journal_collection;

class JournalEditorSaga {
  Iterable<void> saga() sync* {
    yield TakeEvery(_handleInitializeJournalEditor, pattern: InitializeJournalEditor);
    yield TakeEvery(_handleSaveJournalEntry, pattern: SaveJournalEntry);
    yield TakeEvery(_handleUpdateUrlMetadata, pattern: AddUrlMetadataToJournalEntry);
    yield TakeEvery(_handleRemoveUrlMetadata, pattern: RemoveUrlMetadataFromJournalEntry);
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
      var currentJournalIdResult = redux_saga.Result<String?>();
      yield redux_saga.Select(
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
    // For now, still use Isar for JournalTemplateRepository
    var isarResult = redux_saga.Result<dynamic>();
    yield GetContext('isar', result: isarResult);
    var isar = isarResult.value!;
    var journalTemplateRepository = JournalTemplateRepository(isar);

    var cblResult = redux_saga.Result<cbl.Database>();
    yield GetContext('cbl', result: cblResult);
    cbl.Database cblDatabase = cblResult.value!;

    JournalEntryRepository journalEntryRepository = JournalEntryRepository(cblDatabase);

    yield Try(() sync* {
      if (action.journalEntryId != null) {
        // Existing entry found, convert it to entity and dispatch success action
        var journalEntryResult = redux_saga.Result<journal_collection.JournalEntry?>();
        yield Call(journalEntryRepository.getJournalEntryById,
            args: [action.journalEntryId], result: journalEntryResult);

        if (journalEntryResult.value != null) {
          yield Put(InitializeJournalEditorSuccessAction(journalEntryRepository.toEntity(journalEntryResult.value!)));
        } else {
          yield Put(InitializeJournalEditorFailureAction("Journal entry not found"));
        }
      } else if (action.template != null && action.template?.id != null) {
        // Fetch the journal template to get the questions
        var journalTemplateResult = redux_saga.Result<JournalTemplateEntity>();
        yield Call(journalTemplateRepository.getJournalTemplateById,
            args: [action.template!.templateID], result: journalTemplateResult);

        if (journalTemplateResult.value != null) {
          JournalTemplateEntity journalTemplate = journalTemplateResult.value!;

          // Create a new entry with questions initialized from the template
          String newId = Helpers.generateUniqueId();
          DateTime now = DateTime.now();

          // Create question-answer pairs
          List<journal_collection.QuestionAnswerPair> questions = journalTemplate.questions
              .map((question) => journal_collection.QuestionAnswerPair(
                  id: question.id, questionId: question.id, questionText: question.text, answerText: ""))
              .toList();

          // Create the new journal entry using the factory constructor
          journal_collection.JournalEntry newJournalEntry = journal_collection.JournalEntry(
              id: newId,
              templateId: action.template!.id,
              timestamp: action.timestamp ?? now,
              createdAt: now,
              updatedAt: now,
              questions: questions,
              isDeleted: false);

          yield Call(journalEntryRepository.addOrUpdateJournalEntry, args: [newJournalEntry]);
          yield Put(InitializeJournalEditorSuccessAction(journalEntryRepository.toEntity(newJournalEntry)));
        } else {
          yield Put(InitializeJournalEditorFailureAction("Journal template not found"));
        }
      }
    }, Catch: (e, s) sync* {
      yield Put(InitializeJournalEditorFailureAction(e.toString()));
    });
  }

  _handleSaveJournalEntry({required SaveJournalEntry action}) sync* {
    var cblResult = redux_saga.Result<cbl.Database>();
    yield GetContext('cbl', result: cblResult);
    cbl.Database cblDatabase = cblResult.value!;

    JournalEntryRepository journalEntryRepository = JournalEntryRepository(cblDatabase);

    yield Try(() sync* {
      // Fetch the existing journal entry if it exists
      var journalEntryResult = redux_saga.Result<journal_collection.JournalEntry?>();
      yield Call(journalEntryRepository.getJournalEntryById,
          args: [action.journalEntry.id], result: journalEntryResult);

      DateTime now = DateTime.now();

      // Convert questions
      List<journal_collection.QuestionAnswerPair>? questions = action.journalEntry.questions
          ?.map((q) => journal_collection.QuestionAnswerPair(
              id: q.id, questionId: q.questionId, questionText: q.questionText, answerText: q.answerText))
          .toList();

      // Convert text entries
      List<journal_collection.TextEntry>? textEntries = action.journalEntry.textEntries
          ?.map((t) => journal_collection.TextEntry(id: t.id, content: t.content))
          .toList();

      // Convert voice entries
      List<journal_collection.VoiceEntry>? voiceEntries = action.journalEntry.voiceEntries
          ?.map(
              (v) => journal_collection.VoiceEntry(id: v.id, filePath: v.filePath, duration: v.duration, hash: v.hash))
          .toList();

      // Convert video entries
      List<journal_collection.VideoEntry>? videoEntries = action.journalEntry.videoEntries
          ?.map(
              (v) => journal_collection.VideoEntry(id: v.id, filePath: v.filePath, duration: v.duration, hash: v.hash))
          .toList();

      // Convert image entries
      List<journal_collection.ImageEntry>? imageEntries = action.journalEntry.imageEntries
          ?.map((i) => journal_collection.ImageEntry(id: i.id, filePath: i.filePath, caption: i.caption, hash: i.hash))
          .toList();

      // Convert bullet point entries
      List<journal_collection.BulletPointEntry>? bulletPointEntries = action.journalEntry.bulletPointEntries
          ?.map((b) => journal_collection.BulletPointEntry(id: b.id, points: b.points))
          .toList();

      // Convert pain note entries
      List<journal_collection.PainNoteEntry>? painNoteEntries = action.journalEntry.painNoteEntries
          ?.map((p) => journal_collection.PainNoteEntry(id: p.id, painLevel: p.painLevel, notes: p.notes))
          .toList();

      // Convert metadata
      journal_collection.JournalEntryMetadata? metadata = action.journalEntry.metadata != null
          ? journal_collection.JournalEntryMetadata(tags: action.journalEntry.metadata!.tags)
          : null;

      // Convert URL metadata
      List<journal_collection.UrlMetadata>? urlMetadata = action.journalEntry.urlMetadata
          ?.map((u) => journal_collection.UrlMetadata(
              id: u.id,
              url: u.url,
              title: u.title,
              description: u.description,
              image: u.image,
              logo: u.logo,
              body: u.body))
          .toList();

      // Create or update the journal entry using the factory constructor
      journal_collection.JournalEntry journalEntry;

      if (journalEntryResult.value != null) {
        // Use existing entry's values for required fields if they're not in the action
        journalEntry = journal_collection.JournalEntry(
            id: action.journalEntry.id,
            templateId: action.journalEntry.templateId,
            timestamp: action.journalEntry.timestamp,
            createdAt: journalEntryResult.value!.createdAt,
            updatedAt: now,
            questions: questions,
            textEntries: textEntries,
            voiceEntries: voiceEntries,
            videoEntries: videoEntries,
            imageEntries: imageEntries,
            bulletPointEntries: bulletPointEntries,
            painNoteEntries: painNoteEntries,
            metadata: metadata,
            urlMetadata: urlMetadata,
            lock: action.journalEntry.lock,
            title: action.journalEntry.title,
            body: action.journalEntry.body,
            isDeleted: false);
      } else {
        // Create new entry with current timestamp
        journalEntry = journal_collection.JournalEntry(
            id: action.journalEntry.id,
            templateId: action.journalEntry.templateId,
            timestamp: action.journalEntry.timestamp,
            createdAt: now,
            updatedAt: now,
            questions: questions,
            textEntries: textEntries,
            voiceEntries: voiceEntries,
            videoEntries: videoEntries,
            imageEntries: imageEntries,
            bulletPointEntries: bulletPointEntries,
            painNoteEntries: painNoteEntries,
            metadata: metadata,
            urlMetadata: urlMetadata,
            lock: action.journalEntry.lock,
            title: action.journalEntry.title,
            body: action.journalEntry.body,
            isDeleted: false);
      }

      yield Call(journalEntryRepository.addOrUpdateJournalEntry, args: [journalEntry]);
      yield Put(JournalEntrySaved("Journal entry saved successfully."));
      yield Put(const SyncJournalEntries());
      yield Put(LoadJournalEntriesListAction(0, 3000));
    }, Catch: (e, s) sync* {
      yield Put(JournalEntrySaveFailed(e.toString()));
    });
  }

  _handleUpdateUrlMetadata({
    required AddUrlMetadataToJournalEntry action,
  }) sync* {
    var cblResult = redux_saga.Result<cbl.Database>();
    yield GetContext('cbl', result: cblResult);
    cbl.Database cblDatabase = cblResult.value!;

    JournalEntryRepository journalEntryRepository = JournalEntryRepository(cblDatabase);

    // Fetch the existing journal entry
    var journalEntryResult = redux_saga.Result<journal_collection.JournalEntry?>();
    yield Call(journalEntryRepository.getJournalEntryById, args: [action.journalEntryId], result: journalEntryResult);

    if (journalEntryResult.value != null) {
      // Save the updated journal entry
      yield Try(() sync* {
        // Get the existing journal entry
        journal_collection.JournalEntry existingEntry = journalEntryResult.value!;

        // Create a new metadata object
        journal_collection.UrlMetadata newMetadata = journal_collection.UrlMetadata(
            id: Helpers.generateUniqueId(),
            url: action.url,
            title: action.title,
            description: action.description,
            image: action.image,
            logo: action.logo,
            body: action.body);

        // Create a new list with the existing metadata plus the new one
        List<journal_collection.UrlMetadata> urlMetadataList =
            List<journal_collection.UrlMetadata>.from(existingEntry.urlMetadata ?? []);
        urlMetadataList.add(newMetadata);

        // Create a new journal entry with the updated metadata list
        journal_collection.JournalEntry updatedEntry = journal_collection.JournalEntry(
            id: existingEntry.id,
            templateId: existingEntry.templateId,
            timestamp: existingEntry.timestamp,
            createdAt: existingEntry.createdAt,
            updatedAt: DateTime.now(),
            questions: existingEntry.questions,
            textEntries: existingEntry.textEntries,
            voiceEntries: existingEntry.voiceEntries,
            videoEntries: existingEntry.videoEntries,
            imageEntries: existingEntry.imageEntries,
            bulletPointEntries: existingEntry.bulletPointEntries,
            painNoteEntries: existingEntry.painNoteEntries,
            urlMetadata: urlMetadataList,
            metadata: existingEntry.metadata,
            lock: existingEntry.lock,
            title: existingEntry.title,
            body: existingEntry.body,
            summary: existingEntry.summary,
            keyInsight: existingEntry.keyInsight,
            affirmation: existingEntry.affirmation,
            topics: existingEntry.topics,
            feelings: existingEntry.feelings,
            isDeleted: existingEntry.isDeleted);

        yield Call(journalEntryRepository.addOrUpdateJournalEntry, args: [updatedEntry]);
        yield Put(const AddUrlMetadataToJournalEntrySuccess());
        yield Put(const SyncJournalEntries());
        yield Put(LoadJournalEntriesListAction(0, 3000));
      }, Catch: (e, s) sync* {
        yield Put(AddUrlMetadataToJournalEntryFailure(e.toString()));
      });
    } else {
      yield Put(const AddUrlMetadataToJournalEntryFailure("Journal entry not found."));
    }
  }

  _handleRemoveUrlMetadata({
    required RemoveUrlMetadataFromJournalEntry action,
  }) sync* {
    var cblResult = redux_saga.Result<cbl.Database>();
    yield GetContext('cbl', result: cblResult);
    cbl.Database cblDatabase = cblResult.value!;

    JournalEntryRepository journalEntryRepository = JournalEntryRepository(cblDatabase);

    // Fetch the existing journal entry
    var journalEntryResult = redux_saga.Result<journal_collection.JournalEntry?>();
    yield Call(journalEntryRepository.getJournalEntryById, args: [action.journalEntryId], result: journalEntryResult);

    if (journalEntryResult.value != null) {
      yield Try(() sync* {
        journal_collection.JournalEntry existingEntry = journalEntryResult.value!;

        // Filter out the URL metadata to be removed
        List<journal_collection.UrlMetadata> filteredMetadata =
            (existingEntry.urlMetadata ?? []).where((metadata) => metadata.url != action.url).toList();

        // Create a new journal entry with the filtered metadata list
        journal_collection.JournalEntry updatedEntry = journal_collection.JournalEntry(
            id: existingEntry.id,
            templateId: existingEntry.templateId,
            timestamp: existingEntry.timestamp,
            createdAt: existingEntry.createdAt,
            updatedAt: DateTime.now(),
            questions: existingEntry.questions,
            textEntries: existingEntry.textEntries,
            voiceEntries: existingEntry.voiceEntries,
            videoEntries: existingEntry.videoEntries,
            imageEntries: existingEntry.imageEntries,
            bulletPointEntries: existingEntry.bulletPointEntries,
            painNoteEntries: existingEntry.painNoteEntries,
            urlMetadata: filteredMetadata,
            metadata: existingEntry.metadata,
            lock: existingEntry.lock,
            title: existingEntry.title,
            body: existingEntry.body,
            summary: existingEntry.summary,
            keyInsight: existingEntry.keyInsight,
            affirmation: existingEntry.affirmation,
            topics: existingEntry.topics,
            feelings: existingEntry.feelings,
            isDeleted: existingEntry.isDeleted);

        // Update the entry in the repository
        yield Call(journalEntryRepository.addOrUpdateJournalEntry, args: [updatedEntry]);
        yield Put(const RemoveUrlMetadataFromJournalEntrySuccess());
        yield Put(const SyncJournalEntries());
        yield Put(LoadJournalEntriesListAction(0, 3000));
      }, Catch: (e, s) sync* {
        yield Put(RemoveUrlMetadataFromJournalEntryFailure(e.toString()));
      });
    } else {
      yield Put(const RemoveUrlMetadataFromJournalEntryFailure("Journal entry not found."));
    }
  }

  _handleUpdateQuestionAnswer({required UpdateQuestionAnswer action}) sync* {
    var cblResult = redux_saga.Result<cbl.Database>();
    yield GetContext('cbl', result: cblResult);
    cbl.Database cblDatabase = cblResult.value!;

    JournalEntryRepository journalEntryRepository = JournalEntryRepository(cblDatabase);

    // Fetch the existing journal entry
    var journalEntryResult = redux_saga.Result<journal_collection.JournalEntry?>();
    yield Call(journalEntryRepository.getJournalEntryById, args: [action.journalEntryId], result: journalEntryResult);

    if (journalEntryResult.value != null) {
      // Save the updated journal entry
      yield Try(() sync* {
        // Get the existing journal entry
        journal_collection.JournalEntry existingEntry = journalEntryResult.value!;

        // Convert the fixed-length list to a growable list
        List<journal_collection.QuestionAnswerPair> questions =
            List<journal_collection.QuestionAnswerPair>.from(existingEntry.questions ?? []);

        // Check if the question exists
        journal_collection.QuestionAnswerPair? questionToUpdate;
        int questionIndex = questions.indexWhere((q) => q.questionId == action.questionId);

        if (questionIndex >= 0) {
          // Question exists, get a reference to it
          questionToUpdate = questions[questionIndex];

          // Create a new question with the updated answer
          journal_collection.QuestionAnswerPair updatedQuestion = journal_collection.QuestionAnswerPair(
              id: questionToUpdate.id ?? Helpers.generateUniqueId(),
              questionId: questionToUpdate.questionId,
              questionText: questionToUpdate.questionText,
              answerText: action.answerText,
              imageEntryIds: questionToUpdate.imageEntryIds,
              videoEntryIds: questionToUpdate.videoEntryIds,
              voiceEntryIds: questionToUpdate.voiceEntryIds);

          // Replace the old question with the updated one
          questions[questionIndex] = updatedQuestion;
        } else {
          // Question doesn't exist, create a new one
          journal_collection.QuestionAnswerPair newQuestion = journal_collection.QuestionAnswerPair(
              id: Helpers.generateUniqueId(),
              questionId: action.questionId,
              questionText: action.questionText,
              answerText: action.answerText);

          // Add the new question to the list
          questions.add(newQuestion);
        }

        // Create a new journal entry with the updated questions list
        journal_collection.JournalEntry updatedEntry = journal_collection.JournalEntry(
            id: existingEntry.id,
            templateId: existingEntry.templateId,
            timestamp: existingEntry.timestamp,
            createdAt: existingEntry.createdAt,
            updatedAt: DateTime.now(),
            questions: questions,
            textEntries: existingEntry.textEntries,
            voiceEntries: existingEntry.voiceEntries,
            videoEntries: existingEntry.videoEntries,
            imageEntries: existingEntry.imageEntries,
            bulletPointEntries: existingEntry.bulletPointEntries,
            painNoteEntries: existingEntry.painNoteEntries,
            urlMetadata: existingEntry.urlMetadata,
            metadata: existingEntry.metadata,
            lock: existingEntry.lock,
            title: existingEntry.title,
            body: existingEntry.body,
            summary: existingEntry.summary,
            keyInsight: existingEntry.keyInsight,
            affirmation: existingEntry.affirmation,
            topics: existingEntry.topics,
            feelings: existingEntry.feelings,
            isDeleted: existingEntry.isDeleted);

        yield Call(journalEntryRepository.addOrUpdateJournalEntry, args: [updatedEntry]);
        yield Put(UpdateQuestionAnswerSuccessAction(
            journalEntryId: action.journalEntryId, questionId: action.questionId, answerText: action.answerText));
        yield Put(const SyncJournalEntries());
        yield Put(LoadJournalEntriesListAction(0, 3000));
      }, Catch: (e, s) sync* {
        yield Put(UpdateQuestionAnswerFailureAction(e.toString()));
      });
    } else {
      yield Put(const UpdateQuestionAnswerFailureAction("Journal entry not found."));
    }
  }
}
