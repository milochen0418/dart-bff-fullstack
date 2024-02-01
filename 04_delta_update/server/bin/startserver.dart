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
      print('Received message: $data');  // 打印接收到的訊息
      try {
        var jsonData = jsonDecode(data); // Attempt to decode JSON
        gameState.update('player', jsonData); // Update state
      } catch (e) {
        print('Error parsing JSON: $e');
        // Handle non-JSON data or other errors
      }

      // Broadcast updated state to all connected clients
      sockets.forEach((s) {
        s.add(gameState.getState());
      });
    }, onDone: () {
      sockets.remove(socket); // Remove socket on disconnection
    });
  });

  print('Server running on ws://localhost:4040');
}
