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
      if (invertedIndex.containsKey(token)) {
        invertedIndex[token] = <String>{};
      }
      invertedIndex[token]!.add(doc.id);
    });
  }

  Set<String> find(String token) {
    // return the set of all of the document IDs that contain the given token
    return invertedIndex[token] ?? Set.identity();
  }

  Document? get(String documentID) {
    return documents[documentID];
  }
}

class Searcher {
  Tokenizer tokenizer;
  Index index;

  Searcher(this.tokenizer, this.index);

  // returns an ordered list of search results by document ID
  List<String> search(String query) {
    // right now we just do a simple set intersection to return documents that contain the entire query
    return tokenizer
        .tokenize(query)
        .toSet()
        .map((queryTerm) => index.find(queryTerm))
        .reduce((combinedResults, queryResults) => combinedResults.intersection(queryResults))
        .toList();
  }
}

void main() {
  print("Implement a search library");
}
