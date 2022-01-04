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
      ..post('/api/addArticle', addArticleHandler)
      ..get('/api/unreadArticles', fetchUnreadArticlesHandler)
      ..post('/api/readArticle', readArticleHandler);
  }

  Future<Response> addArticleHandler(Request request) {
    // todo:
    // - server-side set fields such as "createdAt" (see scribe for more ideas)
    // - fetch (and archive) via Scribe
    // - persist in Sqlite (at least the reading queue)
    // - use scribe response to update search index
    return request
        .readAsString()
        .then((String body) {
          var item = QueueItem.fromJson(json.decode(body));
          db.addToReadingQueue(item);
        })
        .then((_) => Response.ok('Article added'))
        .onError((error, stackTrace) {
          print(stackTrace);
          return Response.internalServerError(body: error.toString());
        });
  }

  Response fetchUnreadArticlesHandler(Request request) {
    final items = db.fetchReadingQueue();
    return Response.ok(json.encode(items));
  }

  Future<Response> readArticleHandler(Request request) {
    return request
        .readAsString()
        .then((String body) {
          var item = QueueItem.fromJson(json.decode(body));
          db.markAsRead(item);
        })
        .then((_) => Response.ok('Article marked as read'))
        .onError((error, stackTrace) {
          print(stackTrace);
          return Response.internalServerError(body: error.toString());
        });
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
