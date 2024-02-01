import 'dart:io';
import 'dart:convert';

class GameState {
  Map<String, dynamic> state = {};

  String getState() => jsonEncode(state);

  void update(String player, dynamic data) {
    state[player] = data;
  }
}

void main() async {
  var gameState = GameState();
  var server = await HttpServer.bind(InternetAddress.loopbackIPv4, 4040);
  var sockets = <WebSocket>[];

  server.transform(WebSocketTransformer()).listen((WebSocket socket) {
    sockets.add(socket);
    socket.add(gameState.getState()); // Send current state on new connection

    socket.listen((data) {
      gameState.update('player', jsonDecode(data)); // Update state
      sockets.forEach((s) {
        s.add(gameState.getState()); // Broadcast updated state
      });
    }, onDone: () {
      sockets.remove(socket); // Remove socket on disconnection
    });
  });

  print('Server running on ws://localhost:4040');
}
