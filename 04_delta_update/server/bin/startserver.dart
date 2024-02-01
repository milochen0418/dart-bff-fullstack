import 'dart:io';
import 'dart:convert';

class GameState {
  Map<String, dynamic> state = {};

  String getState() => jsonEncode(state);

  void update(String clientKey, dynamic data) {
    state[clientKey] = data; // 使用 clientKey 作為唯一標識
  }
}

void main() async {
  var gameState = GameState();
  var server = await HttpServer.bind(InternetAddress.loopbackIPv4, 4040);
  var sockets = <WebSocket>[];

  server.transform(WebSocketTransformer()).listen((WebSocket socket) {
    var clientKey = socket.hashCode.toString(); // 為每個客戶端生成一個唯一標識符

    sockets.add(socket);
    socket.add(gameState.getState()); // 發送當前狀態

    socket.listen((data) {
      print('Received message: $data');
      try {
        var jsonData = jsonDecode(data);
        gameState.update(clientKey, jsonData); // 使用 clientKey 更新狀態
        sockets.forEach((s) {
          s.add(gameState.getState());
        });
      } catch (e) {
        print('Error parsing JSON: $e');
      }
    }, onDone: () {
      sockets.remove(socket);
      gameState.state.remove(clientKey); // 斷線時移除對應的狀態
    });
  });

  print('Server running on ws://localhost:4040');
}
