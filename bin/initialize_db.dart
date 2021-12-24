import 'package:sqlite3/sqlite3.dart';

void createArticlesTable(Database db) {
  db.execute('''
    CREATE TABLE IF NOT EXISTS articles (
      id TEXT NOT NULL PRIMARY KEY,
      url TEXT NOT NULL,
      title TEXT,
      content TEXT,
      updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
      read BOOLEAN
    );
  ''');
  print('Articles table created');
}

void createReadingQueueTable(Database db) {
  db.execute('''
    CREATE TABLE IF NOT EXISTS readingQueue (
      url TEXT NOT NULL PRIMARY KEY,
      read BOOLEAN NOT NULL,
      updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
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
  createReadingQueueTable(db);

  // Don't forget to dispose the database to avoid memory leaks
  db.dispose();
}
