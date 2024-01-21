import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
            ],
          ),
        ),
      ),
    );
  }
}
