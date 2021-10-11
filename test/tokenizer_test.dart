import 'package:codex/tokenizer.dart';
import 'package:test/test.dart';

void main() {
  group('Tokenizer', () {
    test('.split() splits on regular whitespace', () {
      var testString = 'foo bar    baz';
      expect(Tokenizer().split(testString), equals(['foo', 'bar', 'baz']));
    });

    test('.split() splits on newlines and tabs', () {
      var testString = 'foo\tbar\nbaz';
      expect(Tokenizer().split(testString), equals(['foo', 'bar', 'baz']));
    });

    test('.stem() stems words as expected', () {
      var testWords = [
        ['grows', 'grow'],
        ['leaves', 'leav'],
        ['fairly', 'fair'],
        ['cats', 'cat'],
        ['trouble', 'troubl'],
        ['misunderstanding', 'misunderstand'],
        ['friendships', 'friendship'],
        ['easily', 'easili'],
        ['rational', 'ration'],
        ['relational', 'relat'],
      ];
      testWords.forEach((word) {
        expect(Tokenizer().stem(word[0]), equals(word[1]));
      });
    });
  });
}
