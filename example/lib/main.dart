import 'dart:async';

import 'package:flutter/material.dart';
import 'package:freefeos/freefeos.dart';

Future<void> main() async {
  final run = FreeFEOSRunner(
    runner: (app) async => runApp(app),
    plugins: () => [ExamplePlugin()],
    initApi: (open, exec) async {
      Global.open = open;
      Global.exec = exec;
    },
  );
  await run(app: const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: Global.appName,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: MediaQuery.platformBrightnessOf(
            context,
          ),
        ),
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        title: const Text(Global.appName),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            ValueListenableBuilder(
              valueListenable: Global.counter,
              builder: (context, value, child) {
                return Text(
                  value.toString(),
                  style: Theme.of(context).textTheme.headlineMedium,
                );
              },
            ),
            FilledButton(
              onPressed: () => Navigator.of(context, rootNavigator: false).push(
                MaterialPageRoute(
                  builder: (context) {
                    return Scaffold(
                      appBar: AppBar(
                        title: const Text('title'),
                      ),
                      body: const Center(
                        child: Text('body'),
                      ),
                    );
                  },
                ),
              ),
              child: const Text('2'),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Global.exec(
            'example_channel',
            Global.add,
          );
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}

/// Global全局类
class Global {
  const Global();

  static FreeFEOSOpen open = () async {
    return await Future.value();
  };

  static FreeFEOSExec exec = (
    String channel,
    String method, [
    dynamic arguments,
  ]) async {
    return await null;
  };

  /// 应用名称
  static const String appName = 'FreeFEOS 示例应用';

  static const String developerName = 'wyq0918dev';

  /// 计数
  static final ValueNotifier<int> counter = ValueNotifier(0);

  /// 计数器
  static const String add = 'add';
}

final class ExamplePlugin implements FreeFEOSPlugin {
  ExamplePlugin();

  /// “ExampleAuthor”为作者信息,替换为你自己的名字即可,通过[pluginAuthor]方法定义.
  @override
  String get pluginAuthor => 'ExampleAuthor';

  /// “example_channel”为插件的通道,可以理解为插件的唯一标识,我们通常使用全小写英文字母加下划线的命名方式,通过[pluginChannel]方法定义.
  @override
  String get pluginChannel => 'example_channel';

  /// "Example description"为插件的描述,通过[pluginDescription]方法定.
  @override
  String get pluginDescription => 'Example description';

  /// “Example Plugin”为插件的名称,通过[pluginName]方法定义.
  @override
  String get pluginName => 'ExamplePlugin';

  @override
  Widget pluginWidget(BuildContext context) {
    return const Center(
      child: Text('Hello, World!'),
    );
  }

  /// [onMethodCall]方法为插件的方法调用.
  @override
  Future<dynamic> onMethodCall(String method, [dynamic arguments]) async {
    switch (method) {
      case Global.add:
        return Global.counter.value++;
      default:
        return await null;
    }
  }
}
