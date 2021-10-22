import 'package:sqlite3/sqlite3.dart';

class DB {
  Database sqliteDB;

  DB(String filename) : sqliteDB = sqlite3.open(filename);

  void insertIntegTest(String value) {
    sqliteDB.execute('INSERT INTO integ (unique_value) VALUES(?)', [value]);
  }
}
