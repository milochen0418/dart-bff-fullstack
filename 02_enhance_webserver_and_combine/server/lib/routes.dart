import 'package:shelf/shelf.dart';

Response routesHandler(Request request) {
  if (request.url.path == 'hello') {
    return Response.ok('Hello, world!');
  }

  return Response.notFound('Not Found');
}
