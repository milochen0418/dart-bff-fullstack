import 'package:flutter/material.dart';
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
  late WebSocket _webSocket;
  String _serverMessage = '';

  @override
  void initState() {
    super.initState();
    _connectToServer();
  }

  void _connectToServer() async {
    _webSocket = await WebSocket.connect('ws://localhost:4040');
    _webSocket.listen((data) {
      setState(() {
        _serverMessage = data;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('WebSocket Demo')),
      body: Center(child: Text('Server says: $_serverMessage')),
    );
  }
}
