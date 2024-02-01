import 'package:test/test.dart';
import 'package:startserver/server.dart';
import 'package:shelf/shelf.dart';

void main() {
  test('Integer addition', () {
    expect(1 + 1, equals(2));
  });
  
  test('GET /hello returns Hello, world!', () async {
    var server = createServer();

    var request = Request('GET', Uri.parse('http://localhost:8080/hello'));
    var response = await server(request);

    expect(response.statusCode, equals(200));
    expect(response.readAsString(), completion(equals('Hello, world!')));
  });
}
