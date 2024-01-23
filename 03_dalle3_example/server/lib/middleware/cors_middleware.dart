import 'package:shelf/shelf.dart';

// CORS middleware
Middleware corsMiddleware() {
  return createMiddleware(
    requestHandler: (Request request) {
      if (request.method == 'OPTIONS') {
        return Response.ok('', headers: {
          'Access-Control-Allow-Origin': '*',
          'Access-Control-Allow-Headers': 'Origin, Content-Type, X-Auth-Token',
          'Access-Control-Allow-Methods': 'GET, POST, PUT, DELETE, OPTIONS',
        });
      }
      return null;
    },
    responseHandler: (Response response) => 
      response.change(headers: {'Access-Control-Allow-Origin': '*'}),
  );
}
