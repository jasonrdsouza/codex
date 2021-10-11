class Document {
  String id;
  String url; // todo: better data type?
  String title;
  String content;

  // todo: generate the id automatically? or maybe based on the content-type?
  Document(this.id, this.url, this.title, this.content);
}
