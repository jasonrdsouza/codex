import 'dart:convert';
import 'dart:io';

import 'package:codex/tokenizer.dart';
import 'package:codex/document.dart';

class Index {
  Tokenizer tokenizer;
  late Map<String, Document> documents;
  late Map<String, Set<String>> invertedIndex;

  Index(this.tokenizer)
      : documents = {},
        invertedIndex = {};

  Index.fromFile(this.tokenizer, File indexFile, File documentDumpFile) {
    const decoder = JsonDecoder();

    invertedIndex = decoder.convert(indexFile.readAsStringSync());
    documents = decoder.convert(documentDumpFile.readAsStringSync());
  }

  void dump(File indexFile, File documentDumpFile) {
    // todo: compress before writing to/ reading from disk
    const encoder = JsonEncoder();

    indexFile.writeAsStringSync(encoder.convert(invertedIndex));
    documentDumpFile.writeAsStringSync(encoder.convert(documents));
  }

  void add(Document doc) {
    if (documents.containsKey(doc.id)) {
      print('Overwriting existing entry');
    }
    documents[doc.id] = doc;

    tokenizer.tokenize(doc.content).toSet().forEach((token) {
      if (!invertedIndex.containsKey(token)) {
        invertedIndex[token] = <String>{};
      }
      invertedIndex[token]!.add(doc.id);
    });
  }

  int size() {
    return documents.length;
  }

  Set<String> find(String token) {
    // return the set of all of the document IDs that contain the given token
    return invertedIndex[token] ?? Set.identity();
  }

  Document? get(String documentID) {
    return documents[documentID];
  }
}
