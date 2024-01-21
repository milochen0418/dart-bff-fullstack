import 'dart:math';
import 'package:shelf/shelf.dart';

Response routesHandler(Request request) {
  if (request.url.path == 'hello') {
    return Response.ok('Hello, world!');
  } else if (request.url.path == 'randomString') {
    var randomString = _generateRandomString(16);
    return Response.ok(randomString);
  }
  return Response.notFound('Not Found');
}

String _generateRandomString(int length) {
  const characters = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
  final random = Random();
  return String.fromCharCodes(Iterable.generate(length, (_) => characters.codeUnitAt(random.nextInt(characters.length))));
}