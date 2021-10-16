/* Needed components
 * - document ingestor/ defined format
 * - searcher
 *  - uses the inverted index to pull query matches
 *  - ranks the results (TF-IDF... should this be seperate?)
 */

import 'package:codex/tokenizer.dart';
import 'package:codex/index.dart';

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
