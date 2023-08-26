import 'package:flutter/material.dart';

void main() {
  runApp(const RealWorldApp());
}

class RealWorldApp extends StatelessWidget {
  const RealWorldApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.red),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

