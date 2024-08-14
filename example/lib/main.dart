import 'package:flutter/material.dart';
import 'package:freefeos/freefeos.dart';

Future<void> main() async {
  runFreeFEOSApp(
    runner: (app) async => runApp(app),
    plugins: () => const [],
    app: (context, open, exec) => const MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('flutter_rust_bridge quickstart')),
        body: const Center(
          child: Text('Action: Call Rust `greet("Tom")`\nResult: "Tom"'),
        ),
      ),
    );
  }
}
