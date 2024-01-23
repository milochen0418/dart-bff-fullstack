import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  //String imageUrl = '';
  String imageUrl = 'https://picsum.photos/250?image=9';
  final TextEditingController promptController = TextEditingController();
  void generateImage() async {
    var response = await http.post(
      Uri.parse('http://localhost:8080/generate'),
      body: {'prompt': promptController.text},
    );
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      setState(() {
        imageUrl = data['imageUrl'];
      });
    }
  }

  String _randomString = '';

  void _getRandomString() async {
    final response = await http.get(Uri.parse('http://localhost:8080/randomString'));
    //In the android emulator , you need to do `adb reverse tcp:8080 tcp:8080`
    
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
          title: const Text('Dart server +Flutter UI '),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min, // 將 Column 的大小設為最小
            children: [
              const Text(
                'Hello DALLE-3 Flutter BFF App',
                style: TextStyle(fontSize: 24),
              ),
              const SizedBox(height: 20), // 添加一些空間
              TextField(controller: promptController),
              const SizedBox(height: 20), // 添加一些空間
              ElevatedButton(
                onPressed: generateImage,
                child: Text('Generate Image'),
              ),              
              const SizedBox(height: 20), // 添加一些空間
              if (imageUrl.isNotEmpty) Image.network(imageUrl),

              /*             
              Image.network(
                'https://picsum.photos/250?image=9',
              ),*/
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
