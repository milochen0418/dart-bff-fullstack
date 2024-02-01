import 'dart:io';
import 'dart:convert';

class GameState {
  Map<String, dynamic> state = {};
  Map<String, DateTime> lastUpdated = {};

  // 獲取狀態的 Delta 更新
  String getStateDelta(String clientKey) {
    final lastUpdateTime = lastUpdated[clientKey] ?? DateTime.fromMillisecondsSinceEpoch(0);
    var delta = state.entries.where((entry) {
      // 確保在比較之前將 timestamp 從字符串轉換為 DateTime
      var timestamp = DateTime.tryParse(entry.value['timestamp'] ?? '') ?? DateTime.fromMillisecondsSinceEpoch(0);
      return timestamp.isAfter(lastUpdateTime);
    }).map((entry) => MapEntry(entry.key, entry.value));

    lastUpdated[clientKey] = DateTime.now();
    return jsonEncode(Map.fromEntries(delta));
  }

  void update(String key, dynamic value) {
   // 將 DateTime 對象轉換為 ISO 8601 格式的字符串
    value['timestamp'] = DateTime.now().toIso8601String();
    state[key] = value;    
  }
}

void main() async {
  var gameState = GameState();
  var server = await HttpServer.bind(InternetAddress.loopbackIPv4, 4040);
  var sockets = <WebSocket>[];

  server.transform(WebSocketTransformer()).listen((WebSocket socket) {
    var clientKey = socket.hashCode.toString();
    sockets.add(socket);

    // 發送當前或 Delta 狀態
    socket.add(gameState.getStateDelta(clientKey));

    socket.listen((data) {
      print('Received message: $data');
      try {
        var jsonData = jsonDecode(data);
        gameState.update(clientKey, jsonData);
        sockets.forEach((s) {
          s.add(gameState.getStateDelta(s.hashCode.toString()));
        });
      } catch (e) {
        print('Error parsing JSON: $e');
      }
    }, onDone: () {
      sockets.remove(socket);
      gameState.lastUpdated.remove(clientKey);
    });
  });

  print('Server running on ws://localhost:4040');
}
