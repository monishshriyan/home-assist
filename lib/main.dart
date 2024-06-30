import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HomeAssist',
      theme: ThemeData(),
      home: Scaffold(
        body: const Center(child: Text("hello flutter")),
        appBar: AppBar(
          title: const Center(child: Text("HomeAssist")),
          backgroundColor: Colors.deepPurple,
        ),
      ),
    );
  }
}
