import 'package:sqlite3/sqlite3.dart';

void createArticlesTable(Database db) {
  db.execute('''
    CREATE TABLE articles (
      id TEXT NOT NULL PRIMARY KEY,
      url TEXT NOT NULL,
      title TEXT,
      content TEXT,
      read BOOLEAN
    );
  ''');
  print('Articles table created');
}

void createIntegTestTable(Database db) {
  db.execute('''
    CREATE TABLE integ (
      unique_value TEXT NOT NULL PRIMARY KEY
    );
  ''');
  print('Integ test table created');
}

void main() {
  print('Using sqlite3 ${sqlite3.version}');

  // Create a new in-memory database. To use a database backed by a file, you
  // can replace this with sqlite3.open(yourFilePath).
  // final db = sqlite3.openInMemory();
  final db = sqlite3.open('db/codex.db');

  createArticlesTable(db);
  createIntegTestTable(db);

  // Don't forget to dispose the database to avoid memory leaks
  db.dispose();
}
