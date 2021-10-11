/* Needed components
 * - document ingestor/ defined format
 * - searcher
 *  - uses the inverted index to pull query matches
 *  - ranks the results (TF-IDF... should this be seperate?)
 */

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
    const encoder = JsonEncoder();

    indexFile.writeAsStringSync(encoder.convert(invertedIndex));
    documentDumpFile.writeAsStringSync(encoder.convert(documents));
  }

  void add(Document doc) {
    if (documents.containsKey(doc.id)) {
      print('Overwriting existing entry');
    }
    documents[doc.id] = doc;

    tokenizer.tokenize(doc).toSet().forEach((token) {
      if (invertedIndex.containsKey(token)) {
        invertedIndex[token] = <String>{};
      }
      invertedIndex[token]!.add(doc.id);
    });
  }
}

class Searcher {
  Tokenizer tokenizer;
  Index index;

  Searcher(this.tokenizer, this.index);

  // returns an ordered list of search results
  List<Document> search(String query) {
    return [];
  }
}

void main() {
  print("Implement a search library");
}
