import 'package:shelf/shelf.dart';
import 'package:startserver/routes.dart';
import 'middleware/cors_middleware.dart'; // 引入 CORS middleware 

Handler createServer() {
  var handler = const Pipeline()
      .addMiddleware(logRequests())
      .addMiddleware(corsMiddleware()) // 添加 CORS middleware
      .addHandler(routesHandler);

  return handler;
}
