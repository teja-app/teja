import 'package:redux/redux.dart';
import 'package:teja/domain/entities/journal_entry_entity.dart';
import 'package:teja/domain/entities/journal_template_entity.dart';
import 'package:teja/domain/redux/app_state.dart';
import 'package:teja/domain/redux/journal/journal_editor/journal_editor_actions.image.dart';
import 'package:teja/domain/redux/journal/journal_editor/journal_editor_actions.video.dart';
import 'package:teja/infrastructure/database/isar_collections/journal_entry.dart';

class JournalQuestionViewModel {
  final JournalEntryEntity journalEntry;
  final int questionIndex;
  final int currentPageIndex;
  JournalTemplateEntity? template;
  final List<ImageEntryEntity>? imageEntries;
  final List<VideoEntryEntity>? videoEntries;

  final Function(String journalEntryId, String questionAnswerPairId, ImageEntry imageEntry) addImage;
  final Function(String journalEntryId, String questionAnswerPairId, VideoEntry videoEntry) addVideo;

  JournalQuestionViewModel({
    required this.journalEntry,
    required this.questionIndex,
    required this.currentPageIndex,
    required this.addImage,
    required this.addVideo,
    this.imageEntries,
    this.template,
    this.videoEntries,
  });

  static JournalQuestionViewModel fromStore(Store<AppState> store, int questionIndex) {
    final currentJournalEntry = store.state.journalEditorState.currentJournalEntry!;
    JournalTemplateEntity? template;
    if (currentJournalEntry.templateId != null) {
      template = store.state.journalTemplateState.templatesById[currentJournalEntry.templateId];
    }

    final imageEntryIds = currentJournalEntry.questions![questionIndex].imageEntryIds;

    final imageEntries = currentJournalEntry.imageEntries == null
        ? null
        : List<ImageEntryEntity>.from(
            currentJournalEntry.imageEntries!.where(
              (entry) {
                return imageEntryIds?.contains(entry.id) ?? false;
              },
            ).map((entry) => (entry)),
          );

    final videoEntryIds = currentJournalEntry.questions![questionIndex].videoEntryIds;

    final videoEntries = currentJournalEntry.videoEntries == null
        ? null
        : List<VideoEntryEntity>.from(
            currentJournalEntry.videoEntries!.where(
              (entry) {
                return videoEntryIds?.contains(entry.id) ?? false;
              },
            ).map((entry) => (entry)),
          );

    return JournalQuestionViewModel(
      journalEntry: currentJournalEntry,
      currentPageIndex: store.state.journalEditorState.currentPageIndex,
      questionIndex: questionIndex,
      template: template,
      imageEntries: imageEntries,
      addImage: (journalEntryId, questionAnswerPairId, imageEntry) => store.dispatch(AddImageToQuestionAnswerPair(
        journalEntryId: journalEntryId,
        questionAnswerPairId: questionAnswerPairId,
        imageEntry: imageEntry,
      )),
      videoEntries: videoEntries,
      addVideo: (journalEntryId, questionAnswerPairId, videoEntry) => store.dispatch(AddVideoToQuestionAnswerPair(
        journalEntryId: journalEntryId,
        questionAnswerPairId: questionAnswerPairId,
        videoEntry: videoEntry,
      )),
    );
  }
}
