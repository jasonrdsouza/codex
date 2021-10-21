import 'dart:convert';

class Document {
  late String id;
  late String url; // todo: better data type?
  late String title;
  late String content;

  // todo: generate the id automatically? or maybe based on the content-type?
  Document(this.id, this.url, this.title, this.content);

  Document.fromJsonString(String jsonString) {
    const decoder = JsonDecoder();

    var decodedDoc = decoder.convert(jsonString) as Map<String, String>;
    id = decodedDoc['id']!;
    url = decodedDoc['url']!;
    title = decodedDoc['title']!;
    content = decodedDoc['content']!;
  }

  Document.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        url = json['url'],
        title = json['title'],
        content = json['content'];

  Map<String, dynamic> toJson() => {
        'id': id,
        'url': url,
        'title': title,
        'content': content,
      };

  @override
  bool operator ==(d) =>
      d is Document &&
      d.id == id &&
      d.url == url &&
      d.title == title &&
      d.content == content;
}
