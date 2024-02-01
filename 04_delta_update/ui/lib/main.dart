import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:io';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WebSocket Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  WebSocket? _webSocket;
  String _serverMessage = 'No data received';
  TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _connectToServer();
  }

  void _connectToServer() async {
    try {
      _webSocket = await WebSocket.connect('ws://localhost:4040');
      _webSocket!.listen((data) {
        setState(() {
          _mergeServerMessage(jsonDecode(data));
        });
      });
    } catch (e) {
      setState(() {
        _serverMessage = "Error: ${e.toString()}";
      });
    }
  }

void _mergeServerMessage(Map<String, dynamic> newData) {
  // 確保 _serverMessage 是有效的 JSON 字符串
  if (_serverMessage.isNotEmpty && _serverMessage != 'No data received') {
    // 解碼當前服務器消息
    Map<String, dynamic> currentData = jsonDecode(_serverMessage);

    // 合併新數據
    newData.forEach((key, value) {
      currentData[key] = value;
    });

    // 將合併後的數據編碼回字符串
    _serverMessage = jsonEncode(currentData);
  } else {
    // 如果 _serverMessage 不是有效的 JSON，則直接設置新數據
    _serverMessage = jsonEncode(newData);
  }
}
  

  void _sendMessage() {
    if (_webSocket != null && _controller.text.isNotEmpty) {
      var message = jsonEncode({"message": _controller.text});
      _webSocket!.add(message);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('WebSocket Demo'),
        centerTitle: true,
      ),
      body: Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(
              'Server says:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              _serverMessage,
              style: TextStyle(fontSize: 16, color: Colors.grey[700]),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: 'Send a message',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: _sendMessage,
              child: Text('Send'),
              style: ElevatedButton.styleFrom(
                primary: Colors.blue, // button color
                onPrimary: Colors.white, // text color
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _webSocket?.close();
    _controller.dispose();
    super.dispose();
  }
}
