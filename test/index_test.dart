import 'dart:io';

import 'package:codex/document.dart';
import 'package:codex/index.dart';
import 'package:codex/tokenizer.dart';
import 'package:test/test.dart';

void main() {
  var testDocuments = [
    Document('1', 'http://example.com/1', 'Test Document 1', 'This is the first test document'),
    Document('2', 'http://example.com/2', 'Test Document 2', 'The second test document'),
    Document('3', 'http://example.com/3', 'Test Document 3', 'Document 3'),
  ];

  group('Index', () {
    test('can be initialized', () {
      var index = Index(Tokenizer());
      expect(index.size(), equals(0));
    });

    test('can have documents added to it', () {
      var index = Index(Tokenizer());
      index.add(testDocuments[0]);
      expect(index.size(), equals(1));

      index.add(testDocuments[1]);
      index.add(testDocuments[2]);

      var expectedInvertedIndex = {
        'first': {'1'},
        'test': {'1', '2'},
        'document': {'1', '2', '3'},
        'second': {'2'},
        '3': {'3'}
      };
      expect(index.invertedIndex, equals(expectedInvertedIndex));
    });

    test('vends requested documents by ID', () {
      var index = Index(Tokenizer());
      for (var doc in testDocuments) {
        index.add(doc);
      }

      expect(index.size(), equals(testDocuments.length));

      for (var doc in testDocuments) {
        expect(index.get(doc.id), equals(doc));
      }
    });

    test('returns documents associated with a given token', () {
      var index = Index(Tokenizer());
      for (var doc in testDocuments) {
        index.add(doc);
      }

      expect(index.find('superfluous'), equals(<String>{}));
      expect(index.find('test'), equals({'1', '2'}));
      expect(index.find('document'), equals({'1', '2', '3'}));
    });

    test('serializes to disk correctly', () {
      var tokenizer = Tokenizer();
      var index = Index(tokenizer);
      for (var doc in testDocuments) {
        index.add(doc);
      }

      var indexFile = File('test/index.json');
      var documentDumpFile = File('test/documents.json');
      index.dump(indexFile, documentDumpFile);

      var deserializedIndex = Index.fromFile(tokenizer, indexFile, documentDumpFile);
      expect(index.size(), deserializedIndex.size());
      expect(index.invertedIndex, equals(deserializedIndex.invertedIndex));
      expect(index.documents, equals(deserializedIndex.documents));
    });
  });
}
