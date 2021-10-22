import 'dart:convert';
import 'dart:io';

import 'package:codex/config.dart';
import 'package:codex/db.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:shelf_router/shelf_router.dart' as shelf_router;
import 'package:shelf_static/shelf_static.dart' as shelf_static;

class Server {
  Config config;
  InternetAddress listenAddr = InternetAddress.loopbackIPv4;
  late final int port;
  late DB db;
  late Handler staticHandler;
  late shelf_router.Router router;

  Server(this.config) {
    port = config.port();
    db = DB(config.dbPath());
    staticHandler = shelf_static.createStaticHandler(config.staticDir(),
        defaultDocument: 'index.html');
    router = registerRoutes();
  }

  shelf_router.Router registerRoutes() {
    return shelf_router.Router()
      ..get('/helloworld', helloWorldHandler)
      ..get('/time', timeHandler)
      ..get('/sum/<a|[0-9]+>/<b|[0-9]+>', sumHandler)
      ..get('/dbTest/<value>', dbTestHandler)
      ..post('/api/addArticle', addArticleHandler)
      ..post('/api/readArticle', readArticleHandler);
  }

  Response dbTestHandler(Request request, String value) {
    db.insertIntegTest(value);
    return Response.ok('Inserted $value');
  }

  Future run() async {
    // See https://pub.dev/documentation/shelf/latest/shelf/Cascade-class.html
    final cascade = Cascade()
        // First, serve files from the static directory
        .add(staticHandler)
        // If a corresponding file is not found, send requests to a `Router`
        .add(router);

    // See https://pub.dev/documentation/shelf/latest/shelf_io/serve.html
    final server = await shelf_io.serve(
      // See https://pub.dev/documentation/shelf/latest/shelf/logRequests.html
      logRequests()
          // See https://pub.dev/documentation/shelf/latest/shelf/MiddlewareExtensions/addHandler.html
          .addHandler(cascade.handler),
      listenAddr, // Allows only local connections
      port,
    );

    print('Serving at http://${server.address.host}:${server.port}');
  }
}

Future main() async => Server(Config.standard()).run();

Response helloWorldHandler(Request request) => Response.ok('Hello, World!');

Response timeHandler(Request request) =>
    Response.ok(DateTime.now().toUtc().toIso8601String());

Response addArticleHandler(Request request) {
  // todo:
  // - JSON parse request body
  // - define fields such as "articleUrl", "addToReadingQueue", "refreshCache", etc
  // - server-side set fields such as "createdAt" (see scribe for more ideas)
  // - fetch (and archive) via Scribe
  // - use scribe response to update search index
  // - persist in Sqlite (at least the reading queue)
  return Response.ok('Unimplemented');
}

Response readArticleHandler(Request request) {
  // todo:
  // - define Json fields like "articleUrl"
  // - track server-side when the article was read (Sqlite)
  return Response.ok('Unimplemented');
}

Response sumHandler(request, String a, String b) {
  final aNum = int.parse(a);
  final bNum = int.parse(b);
  return Response.ok(
    const JsonEncoder.withIndent(' ')
        .convert({'a': aNum, 'b': bNum, 'sum': aNum + bNum}),
    headers: {
      'content-type': 'application/json',
      'Cache-Control': 'public, max-age=604800',
    },
  );
}
