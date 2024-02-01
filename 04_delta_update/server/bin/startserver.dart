import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:startserver/server.dart';

void main() async {
  print('run startserver.dart');
  var server = await createServer();
  await shelf_io.serve(server, 'localhost', 8080);
  print('Server running on localhost:8080');
}