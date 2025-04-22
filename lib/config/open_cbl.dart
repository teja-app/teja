import 'package:cbl/cbl.dart';

/// Opens and returns a Couchbase Lite [Database] instance.
/// You can extend this function to configure collections or indexes as needed.
Future<Database> openCouchbaseLiteDatabase({String dbName = 'app_db'}) async {
  // Open or create the database
  final db = await Database.openAsync(dbName);

  // Optionally, you can create collections or indexes here

  return db;
}
