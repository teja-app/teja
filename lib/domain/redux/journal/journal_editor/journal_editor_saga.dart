import 'package:redux_saga/redux_saga.dart';
import 'package:teja/domain/entities/journal_entry_entity.dart';
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
    yield TakeEvery(_handleAddOrUpdateImage, pattern: AddOrUpdateImageAction);
    yield TakeEvery(_handleRemoveImage, pattern: RemoveImageAction);
    yield TakeEvery(_handleAddImageToQuestionAnswerPair, pattern: AddImageToQuestionAnswerPair);
    yield TakeEvery(_handleRemoveImageFromQuestionAnswerPair, pattern: RemoveImageFromQuestionAnswerPair);
    yield TakeEvery(_handleRefreshImages, pattern: RefreshImagesAction);
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

  _handleAddOrUpdateImage({required AddOrUpdateImageAction action}) sync* {
    var isarResult = Result<Isar>();
    yield GetContext('isar', result: isarResult);
    Isar isar = isarResult.value!;

    var journalEntryRepository = JournalEntryRepository(isar);

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

    var journalEntryRepository = JournalEntryRepository(isar);

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

    var journalEntryRepository = JournalEntryRepository(isar);

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
      print("e $e $s");
      yield Put(AddImageToQuestionAnswerPairFailureAction(e.toString()));
    });
  }

  _handleRemoveImageFromQuestionAnswerPair({required RemoveImageFromQuestionAnswerPair action}) sync* {
    var isarResult = Result<Isar>();
    yield GetContext('isar', result: isarResult);
    Isar isar = isarResult.value!;

    var journalEntryRepository = JournalEntryRepository(isar);

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
