import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:io';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WebSocket Demo',
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
          _serverMessage = data;
        });
      });
    } catch (e) {
      setState(() {
        _serverMessage = "Error: ${e.toString()}";
      });
    }
  }

  void _sendMessage() {
    /*
    if (_webSocket != null && _controller.text.isNotEmpty) {
      _webSocket!.add(_controller.text);
    }*/
    if (_webSocket != null && _controller.text.isNotEmpty) {
      var message = jsonEncode({"message": _controller.text});
      _webSocket!.add(message);
    }    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('WebSocket Demo')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Server says: $_serverMessage'),
            TextField(
              controller: _controller,
              decoration: InputDecoration(labelText: 'Send a message'),
            ),
            ElevatedButton(
              onPressed: _sendMessage,
              child: Text('Send'),
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
