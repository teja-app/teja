import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:archive/archive_io.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:redux_saga/redux_saga.dart';
import 'package:share_plus/share_plus.dart';
import 'package:teja/domain/redux/sync/actions.dart';
import 'package:teja/infrastructure/database/isar_collections/journal_entry.dart';
import 'package:teja/infrastructure/database/isar_collections/mood_log.dart';

class SyncSaga {
  Iterable<void> saga() sync* {
    yield TakeEvery(_exportJSON, pattern: ExportJSONAction);
    yield TakeEvery(_importJSON, pattern: ImportJSONAction);
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
      print("e.toString() ${e.toString()}");
      yield Put(ExportJSONActionFailed(e.toString()));
    });
  }

  Future<FilePickerResult?> pickFile() async {
    return FilePicker.platform.pickFiles();
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
        Result<dynamic> fileBytesResult = Result<dynamic>();
        yield Call(file.readAsBytes, result: fileBytesResult);
        final bytes =
            fileBytesResult.value as Uint8List; // Or simply `fileBytesResult.value` if you're okay with dynamic

        final archive = ZipDecoder().decodeBytes(bytes);

        for (final file in archive) {
          final filename = file.name;
          final data = file.content as List<int>;
          String jsonString = utf8.decode(data);
          dynamic jsonData = jsonDecode(jsonString);

          // Step 3: Import JSON data into Isar collections
          if (filename.contains("journalEntrys")) {
            yield Call(_importJournalEntrys, args: [jsonData, isar]);
          } else if (filename.contains("moodLogs")) {
            yield Call(_importMoodLogs, args: [jsonData, isar]);
          }
          // Add more conditions for other collections
        }
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

    for (var collectionName in collectionNames) {
      // Simulate fetching data for the collection and preparing JSON
      var dataResult = await dynamicFunction(isar, collectionName);
      String jsonString = jsonEncode(dataResult);
      String jsonFilePath = '${directory.path}/$collectionName.json';
      File jsonFile = File(jsonFilePath);
      await jsonFile.writeAsString(jsonString);

      encoder.addFile(jsonFile);
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
