import 'package:sqlite3/sqlite3.dart';

class DB {
  Database sqliteDB;

  DB(String filename) : sqliteDB = sqlite3.open(filename);

  void addToReadingQueue(QueueItem i) {
    sqliteDB.execute('INSERT INTO readingQueue (url, read) VALUES(?, ?)',
        [i.url, i.read ? 1 : 0]);
  }

  void markAsRead(QueueItem i) {
    sqliteDB.execute('UPDATE readingQueue SET read = 1 where url = ?', [i.url]);
  }

  List<QueueItem> fetchReadingQueue() {
    final ResultSet resultSet =
        sqliteDB.select('SELECT url, read from readingQueue');
    return resultSet.map((row) => QueueItem.fromRow(row)).toList();
  }
}

class QueueItem {
  final String url;
  final bool read;
  final bool refresh;
  // todo: support for when the item was added to the queue
  //        generate timestamp in code instead of in SQLITE
  QueueItem(this.url, this.read, this.refresh);

  factory QueueItem.fromJson(Map<String, dynamic> data) {
    final url = data['url'] as String;
    final read = data['read'] as bool?;
    final refresh = data['refresh'] as bool?;
    return QueueItem(url, read ?? false, refresh ?? false);
  }

  Map<String, dynamic> toJson() => {
        'url': url,
        'read': read,
      };

  factory QueueItem.fromRow(Row row) {
    final url = row['url'] as String;
    final read = row['read'] as int;
    return QueueItem(url, read == 1, false);
  }

  @override
  String toString() {
    return 'QueueItem(url: $url, read?: $read, refresh?: $refresh)';
  }
}
