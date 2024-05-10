import 'package:collection/collection.dart';
import 'package:isar/isar.dart';
import 'package:teja/infrastructure/database/isar_collections/journal_entry.dart';

class VoiceEntryRepository {
  final Isar isar;

  VoiceEntryRepository(this.isar);

  Future<void> addOrUpdateVoice(String journalEntryId, VoiceEntry newVoice) async {
    await isar.writeTxn(() async {
      var entry = await isar.journalEntrys.getById(journalEntryId);
      if (entry != null) {
        var voices = entry.voiceEntries ?? [];
        var existingIndex = voices.indexWhere((voice) => voice.hash == newVoice.hash);
        if (existingIndex == -1) {
          voices = List.from(voices)..add(newVoice);
        }
        entry.voiceEntries = voices;
        await isar.journalEntrys.put(entry);
      }
    });
  }

  Future<VoiceEntry?> findVoiceByHash(String journalEntryId, String hash) async {
    var entry = await isar.journalEntrys.getById(journalEntryId);
    if (entry != null && entry.voiceEntries != null) {
      return entry.voiceEntries!.firstWhereOrNull((voice) => voice.hash == hash);
    }
    return null;
  }

  Future<void> removeVoice(String journalEntryId, String voiceHash) async {
    await isar.writeTxn(() async {
      var entry = await isar.journalEntrys.getById(journalEntryId);
      if (entry?.voiceEntries != null) {
        entry!.voiceEntries!.removeWhere((voice) => voice.hash == voiceHash);
        await isar.journalEntrys.put(entry);
      }
    });
  }

  Future<void> linkVoiceToQuestionAnswerPair(String journalEntryId, String questionAnswerPairId, String voiceId) async {
    await isar.writeTxn(() async {
      var entry = await isar.journalEntrys.getById(journalEntryId);
      if (entry != null) {
        var questionAnswerPair = entry.questions?.firstWhereOrNull((q) => q.id == questionAnswerPairId);
        if (questionAnswerPair != null) {
          var voiceEntryIds = List<String>.from(questionAnswerPair.voiceEntryIds ?? []);
          if (!voiceEntryIds.contains(voiceId)) {
            voiceEntryIds.add(voiceId);
            questionAnswerPair.voiceEntryIds = voiceEntryIds;
            await isar.journalEntrys.put(entry);
          }
        }
      }
    });
  }

  Future<void> unlinkVoiceFromQuestionAnswerPair(
      String journalEntryId, String questionAnswerPairId, String voiceId) async {
    await isar.writeTxn(() async {
      var entry = await isar.journalEntrys.getById(journalEntryId);
      if (entry != null) {
        var questionAnswerPair = entry.questions?.firstWhereOrNull((q) => q.id == questionAnswerPairId);
        if (questionAnswerPair != null && questionAnswerPair.voiceEntryIds != null) {
          questionAnswerPair.voiceEntryIds!.removeWhere((id) => id == voiceId);
          await isar.journalEntrys.put(entry);
        }
      }
    });
  }
}
