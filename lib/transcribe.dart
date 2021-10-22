// Helper to call out to Scribe. Could also wrap the readability library directly, but for now
// I think it makes sense to use my hosted version

class Transcriber {
  String scribeUrl;

  Transcriber(this.scribeUrl);
}
