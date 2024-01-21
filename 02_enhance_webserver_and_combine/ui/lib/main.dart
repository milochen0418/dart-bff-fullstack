import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _randomString = '';

  void _getRandomString() async {
    final response = await http.get(Uri.parse('http://localhost:8080/randomString'));
    if (response.statusCode == 200) {
      setState(() {
        _randomString = response.body;
      });
    } else {
      print('Failed to load random string');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Hello World Flutter App!!'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min, // 將 Column 的大小設為最小
            children: [
              const Text(
                'Hello, World~~',
                style: TextStyle(fontSize: 24),
              ),
              const SizedBox(height: 20), // 添加一些空間
              Image.network(
                'https://picsum.photos/250?image=9',
              ),
              ElevatedButton(
                onPressed: _getRandomString,
                child: const Text('Get Server BFF Random'),
              ),
              const SizedBox(height: 20),
              Text(_randomString),
            ],
          ),
        ),
      ),
    );
  }
}
