import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:archive/archive_io.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:redux_saga/redux_saga.dart';
import 'package:share_plus/share_plus.dart';
import 'package:teja/domain/redux/journal/list/journal_list_actions.dart';
import 'package:teja/domain/redux/mood/list/actions.dart';
import 'package:teja/domain/redux/sync/actions.dart';
import 'package:teja/infrastructure/database/isar_collections/journal_entry.dart';
import 'package:teja/infrastructure/database/isar_collections/mood_log.dart';

class SyncSaga {
  Iterable<void> saga() sync* {
    yield TakeEvery(_exportJSON, pattern: ExportJSONAction);
    yield TakeEvery(_importJSON, pattern: ImportJSONAction);
    yield TakeEvery(_deleteAccount, pattern: DeleteAccountAction);
  }

  _deleteAccount({required DeleteAccountAction action}) sync* {
    yield Try(() sync* {
      var isarResult = Result<Isar>();
      yield GetContext('isar', result: isarResult);
      Isar isar = isarResult.value!;

      // Simulate account deletion with an async operation
      var deleteAccountResult = Result<bool>();
      yield Call(_performAccountDeletion, args: [isar], result: deleteAccountResult);

      if (deleteAccountResult.value == true) {
        yield Put(const DeleteAccountActionSuccess());
        yield Put(ResetMoodLogsListAction());
        yield Put(ResetJournalEntriesListAction());
      } else {
        yield Put(const DeleteAccountActionFailed('Account deletion failed'));
      }
    }, Catch: (e, s) sync* {
      yield Put(DeleteAccountActionFailed(e.toString()));
    });
  }

  Future<bool> _performAccountDeletion(Isar isar) async {
    try {
      // Delete moods
      await isar.writeTxn(() async {
        await isar.moodLogs.clear();
      });

      // Delete journals
      await isar.writeTxn(() async {
        await isar.journalEntrys.clear();
      });

      // Delete files
      final documentsDirectory = await getApplicationDocumentsDirectory();
      final files = documentsDirectory.listSync().where((item) {
        // Exclude directories and system files
        return item is File &&
            !item.path.contains('.isar') &&
            !item.path.contains('.hive') &&
            !item.path.contains('.lock');
      }).toList();

      for (var file in files) {
        await file.delete();
      }

      // Return true if deletion was successful
      return true;
    } catch (e) {
      // Handle any errors that occur during the deletion process
      return false;
    }
  }

  _exportJSON({required ExportJSONAction action}) sync* {
    yield Try(() sync* {
      var isarResult = Result<Isar>();
      yield GetContext('isar', result: isarResult);
      Isar isar = isarResult.value!;

      List<String> collectionNames = ['journalEntrys', 'moodLogs']; // Add more as needed
      var tempDirResult = Result<Directory>();
      yield Call(getTemporaryDirectory, result: tempDirResult);
      Directory directory = tempDirResult.value!;

      // Use 'Call' to invoke the async function and wait for the result
      var zipFilePathResult = Result<String>();
      yield Call(prepareAndZipCollections, args: [collectionNames, isar, directory], result: zipFilePathResult);

      // Use the result to share the zip file
      if (zipFilePathResult.value != null) {
        yield Fork(_shareFile, args: [zipFilePathResult.value!]);
      }
    }, Catch: (e, s) sync* {
      yield Put(ExportJSONActionFailed(e.toString()));
    });
  }

  Future<FilePickerResult?> pickFile() async {
    return FilePicker.platform.pickFiles();
  }

  // Helper function to process zip file and extract attachments
  Future<void> _processZipFileAndExtractAttachments(File file, Isar isar) async {
    final bytes = await file.readAsBytes();
    final archive = ZipDecoder().decodeBytes(bytes);

    for (final file in archive) {
      final filename = file.name;
      final data = file.content as List<int>;

      if (filename.endsWith('.json')) {
        // Handle JSON data as before
        String jsonString = utf8.decode(data);
        dynamic jsonData = jsonDecode(jsonString);

        if (filename.contains("journalEntrys")) {
          await _importJournalEntrys(jsonData, isar);
        } else if (filename.contains("moodLogs")) {
          await _importMoodLogs(jsonData, isar);
        }
      } else {
        // Handle attachments
        await saveFileToDocuments(data, filename);
      }
    }
  }

  Future<void> saveFileToDocuments(List<int> data, String filename) async {
    try {
      final documentsDirectory = await getApplicationDocumentsDirectory();
      if (filename.startsWith('/')) {
        filename = filename.substring(1);
      }
      final filePath = path.join(documentsDirectory.path, filename);
      final outputFile = File(filePath);

      // Check if the file already exists
      if (await outputFile.exists()) {
        print('File already exists. Considering handling logic such as renaming or replacing.');
      }

      // Write data to the file
      await outputFile.writeAsBytes(data, flush: true);
      print('File saved successfully at $filePath');
    } catch (e) {
      print('Failed to save file: $e');
      throw FileSystemException('Failed to save file', e.toString());
    }
  }

  _importJSON({required ImportJSONAction action}) sync* {
    yield Try(() sync* {
      var isarResult = Result<Isar>();
      yield GetContext('isar', result: isarResult);
      Isar isar = isarResult.value!;
      // Step 1: Pick the zip file using the helper function
      var filePickResult = Result<FilePickerResult?>();
      yield Call(pickFile, result: filePickResult);
      FilePickerResult? result = filePickResult.value;

      if (result != null && result.files.single.path != null) {
        File file = File(result.files.single.path!);
        yield Call(_processZipFileAndExtractAttachments, args: [file, isar]);
      }
    }, Catch: (e, s) sync* {
      yield Put(ImportJSONActionFailed(e.toString()));
    });
  }

  Future<bool> _importJournalEntrys(dynamic jsonData, Isar isar) async {
    try {
      // Convert jsonData to Uint8List
      final jsonBytes = Uint8List.fromList(utf8.encode(jsonEncode(jsonData)));
      await isar.writeTxn(() async {
        await isar.journalEntrys.clear();
        await isar.journalEntrys.importJsonRaw(jsonBytes);
      });
      return true;
    } catch (e) {
      // Handle or log the error as needed
      return false;
    }
  }

  Future<bool> _importMoodLogs(dynamic jsonData, Isar isar) async {
    try {
      // Convert jsonData to Uint8List
      final jsonBytes = Uint8List.fromList(utf8.encode(jsonEncode(jsonData)));
      await isar.writeTxn(() async {
        await isar.moodLogs.clear();
        await isar.moodLogs.importJsonRaw(jsonBytes);
      });
      return true;
    } catch (e) {
      // Handle or log the error as needed
      return false;
    }
  }

// This is now an async function outside of your class that returns a Future<String>
  Future<String> prepareAndZipCollections(List<String> collectionNames, Isar isar, Directory directory) async {
    var encoder = ZipFileEncoder();
    String zipFilePath = '${directory.path}/tejaBackup.zip';
    encoder.create(zipFilePath);

    // Add JSON data for each collection
    for (var collectionName in collectionNames) {
      // Simulate fetching data for the collection and preparing JSON
      var dataResult = await dynamicFunction(isar, collectionName);
      String jsonString = jsonEncode(dataResult);
      String jsonFilePath = '${directory.path}/$collectionName.json';
      File jsonFile = File(jsonFilePath);
      await jsonFile.writeAsString(jsonString);

      encoder.addFile(jsonFile);
    }

    // Add attachments from the documents directory
    final documentsDirectory = await getApplicationDocumentsDirectory();
    final files = documentsDirectory.listSync().where((item) {
      // Exclude files with extensions .isar and .hive
      return !item.path.contains('.isar') && !item.path.contains('.hive') && !item.path.contains('.lock');
    }).toList();
    for (var file in files) {
      if (file is File) {
        encoder.addFile(file, file.path.substring(documentsDirectory.path.length));
      }
    }

    encoder.close();
    return zipFilePath;
  }

  static dynamic dynamicFunction(Isar isar, String collectionName) {
    switch (collectionName) {
      case 'journalEntrys':
        return isar.journalEntrys.where().exportJson();
      case 'moodLogs':
        return isar.moodLogs.where().exportJson();
      // Add more cases for other collections
      default:
        throw Exception('Collection not found');
    }
  }

// Corrected snippet for an async operation outside of Redux-Saga's generator functions
  static Future<void> _shareFile(String filePath) async {
    XFile xfile = XFile(filePath, mimeType: 'application/zip');
    Rect sharePositionOrigin = Rect.fromLTWH(0, 0, 100, 100); // Adjust as needed
    await Share.shareXFiles([xfile], sharePositionOrigin: sharePositionOrigin);
  }
}
