import 'package:shelf/shelf.dart';
import 'package:startserver/routes.dart';

Handler createServer() {
  var handler = const Pipeline()
      .addMiddleware(logRequests())
      .addHandler(routesHandler);

  return handler;
}
