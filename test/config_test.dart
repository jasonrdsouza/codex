import 'package:codex/config.dart';
import 'package:test/test.dart';

void main() {
  group('Config', () {
    test('can be initialized', () {
      var config = Config.standard();
      expect(config.entries, isMap);
    });

    test('returns the expected results', () {
      var config = Config.standard();
      expect(config.port(), 8080);
      expect(config.dbPath(), 'db/codex.db');
    });
  });
}
