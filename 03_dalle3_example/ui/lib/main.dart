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
  
  String imageUrl = 'https://picsum.photos/250?image=9';
  bool isLoading = false;
  final TextEditingController promptController = TextEditingController();
void generateImage() async {
  setState(() {
    isLoading = true; // 开始加载时设置为true
  });

  var response = await http.post(
    Uri.parse('http://localhost:8080/generate'),
    body: {'prompt': promptController.text},
  );

  if (response.statusCode == 200) {
    var data = json.decode(response.body);
    setState(() {
      imageUrl = data['imageUrl'];
      isLoading = false; // 加载完成后设置为false
    });
  } else {
    setState(() {
      isLoading = false; // 出错时也要设置为false
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
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Dart server + Flutter UI'),
        ),
        body: SingleChildScrollView( // 允许滚动
          padding: const EdgeInsets.all(20.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Hello DALLE-3 Flutter BFF App',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: promptController,
                  decoration: InputDecoration(
                    labelText: 'Enter Prompt',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: generateImage,
                  child: const Text('Generate Image'),
                ),
                const SizedBox(height: 20),

                isLoading
                ? CircularProgressIndicator() // 顯示進度指示器
                : Image.network(imageUrl), // 否則顯示圖片
                const SizedBox(height: 20),

                //Image.network(imageUrl),  
                const Divider(height: 40),
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
      ),
    );
  }

}
