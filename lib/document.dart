import 'dart:convert';

import 'package:quiver/core.dart';

class Document {
  String id;
  String url; // todo: better data type?
  String title;
  String content;

  // todo: generate the id automatically? or maybe based on the content-type?
  Document(this.id, this.url, this.title, this.content);

  factory Document.fromJsonString(String jsonString) {
    const decoder = JsonDecoder();

    var decodedDoc = decoder.convert(jsonString) as Map<String, String>;
    return Document(decodedDoc['id']!, decodedDoc['url']!, decodedDoc['title']!, decodedDoc['content']!);
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
  bool operator ==(Object other) =>
      other is Document && other.id == id && other.url == url && other.title == title && other.content == content;

  @override
  int get hashCode => hash4(id, url, title, content);
}
