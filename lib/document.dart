import 'dart:convert';

class Document {
  late String id;
  late String url; // todo: better data type?
  late String title;
  late String content;

  // todo: generate the id automatically? or maybe based on the content-type?
  Document(this.id, this.url, this.title, this.content);

  Document.fromJson(String jsonString) {
    const decoder = JsonDecoder();

    var decodedDoc = decoder.convert(jsonString) as Map<String, String>;
    id = decodedDoc['id']!;
    url = decodedDoc['url']!;
    title = decodedDoc['title']!;
    content = decodedDoc['content']!;
  }
}
