import 'package:stemmer/stemmer.dart';
import 'package:codex/document.dart';

class Tokenizer {
  // From NLTK library
  Set<String> stopwords = {
    'a',
    'about',
    'above',
    'after',
    'again',
    'against',
    'all',
    'am',
    'an',
    'and',
    'any',
    'are',
    'as',
    'at',
    'be',
    'because',
    'been',
    'before',
    'being',
    'below',
    'between',
    'both',
    'but',
    'by',
    'can',
    'did',
    'do',
    'does',
    'doing',
    'don',
    'down',
    'during',
    'each',
    'few',
    'for',
    'from',
    'further',
    'had',
    'has',
    'have',
    'having',
    'he',
    'her',
    'here',
    'hers',
    'herself',
    'him',
    'himself',
    'his',
    'how',
    'i',
    'if',
    'in',
    'into',
    'is',
    'it',
    'its',
    'itself',
    'just',
    'me',
    'more',
    'most',
    'my',
    'myself',
    'no',
    'nor',
    'not',
    'now',
    'of',
    'off',
    'on',
    'once',
    'only',
    'or',
    'other',
    'our',
    'ours',
    'ourselves',
    'out',
    'over',
    'own',
    's',
    'same',
    'she',
    'should',
    'so',
    'some',
    'such',
    't',
    'than',
    'that',
    'the',
    'their',
    'theirs',
    'them',
    'themselves',
    'then',
    'there',
    'these',
    'they',
    'this',
    'those',
    'through',
    'to',
    'too',
    'under',
    'until',
    'up',
    'very',
    'was',
    'we',
    'were',
    'what',
    'when',
    'where',
    'which',
    'while',
    'who',
    'whom',
    'why',
    'will',
    'with',
    'you',
    'your',
    'yours',
    'yourself',
    'yourselves',
  };
  SnowballStemmer stemmer;

  Tokenizer() : stemmer = SnowballStemmer();

  List<String> split(String content) {
    return content.split(RegExp(r'(\s+)'));
  }

  String unpunctuate(String token) {
    // remove all punctuation? Will this mess up the stemmer?
    return token;
  }

  String normalizeCase(String token) {
    return token.toLowerCase();
  }

  bool isStopWord(String token) {
    return stopwords.contains(token);
  }

  String stem(String token) {
    return stemmer.stem(token);
  }

  List<String> tokenize(Document doc) {
    return split(doc.content)
        .map(normalizeCase)
        .map(unpunctuate)
        .map(stem)
        .where((token) => !isStopWord(token))
        .toList();
  }
}
