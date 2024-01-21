import 'package:test/test.dart';
import 'package:startserver/server.dart';
import 'package:shelf/shelf.dart';

void main() {
  test('GET /hello returns Hello, world!', () async {
    var server = createServer();

    var request = Request('GET', Uri.parse('http://localhost:8080/hello'));
    var response = await server(request);

    expect(response.statusCode, equals(200));
    expect(response.readAsString(), completion(equals('Hello, world!')));
  });
}
