import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../engine/method_call.dart';
import '../engine/plugin_engine.dart';
import '../engine/result.dart';
import '../framework/service.dart';
import '../framework/want.dart';
import '../interface/platform_interface.dart';
import '../platform/freefeos.dart';
import '../plugin/plugin_runtime.dart';
import '../utils/platform.dart';
import '../values/channel.dart';
import '../values/strings.dart';

final class PlatformEmbedder extends Service
    implements RuntimePlugin, FreeFEOSPlatform {
  late FreeFEOSLinker _linker;
  @override
  String get pluginAuthor => developerName;

  @override
  String get pluginChannel => embedderChannel;

  @override
  String get pluginDescription => 'PlatformEmbedder';

  @override
  String get pluginName => 'PlatformEmbedder';

  @override
  void onCreate() {
    super.onCreate();
    if (kUseNative) _linker = FreeFEOSLinker();
  }

  @override
  IBinder onBind(Want want) => EmbedderBinder(embedder: this);

  @override
  Future<dynamic> onMethodCall(
    String method, [
    dynamic arguments,
  ]) async {}

  @override
  Widget pluginWidget(BuildContext context) {
    return const Placeholder();
  }

  @override
  Future<List?> getPlatformPluginList() async {
    return await _invoke(
      invoke: () async {
        return List.empty();
      },
      mobile: (linker) async {
        return await linker.getPlatformPluginList();
      },
      error: (exception) async {
        return List.empty();
      },
    );
  }

  @override
  Future<bool?> openPlatformDialog() async {
    return await _invoke(
      invoke: () async {
        return true;
      },
      mobile: (linker) async {
        return await linker.openPlatformDialog();
      },
      error: (exception) async {
        return false;
      },
    );
  }

  @override
  Future<bool?> closePlatformDialog() async {
    return await _invoke(
      invoke: () async {
        return true;
      },
      mobile: (linker) async {
        return await linker.closePlatformDialog();
      },
      error: (exception) async {
        return false;
      },
    );
  }

  Future<dynamic> _invoke({
    required Future<dynamic> Function() invoke,
    required Future<dynamic> Function(FreeFEOSLinker linker) mobile,
    required Future<dynamic> Function(Exception exception) error,
  }) async {
    if (kIsWeb || kIsWasm) {
      return await invoke.call();
    } else if (kUseNative) {
      try {
        return await mobile.call(_linker);
      } on Exception catch (exception) {
        return await error.call(exception);
      }
    } else {
      try {
        return await invoke.call();
      } on Exception catch (exception) {
        return await error.call(exception);
      }
    }
  }
}

final class EmbedderBinder extends Binder {
  EmbedderBinder({required this.embedder});

  final PlatformEmbedder embedder;

  @override
  Service get getService => embedder;
}

final class EmbedderConnection implements ServiceConnection {
  EmbedderConnection({required this.calback});

  final void Function(PlatformEmbedder embedder) calback;

  @override
  void onServiceConnected(String name, IBinder service) {
    EmbedderBinder binder = service as EmbedderBinder;
    calback.call(binder.getService as PlatformEmbedder);
  }

  @override
  void onServiceDisconnected(String name) {}
}

final class FEPlugin extends Service {
  @override
  void onCreate() {
    super.onCreate();
  }

  @override
  IBinder onBind(Want want) => ServiceBinder(service: this);
}

final class ServiceBinder extends Binder {
  ServiceBinder({required this.service});

  final FEPlugin service;

  @override
  Service get getService => service;
}

final class ServiceInvoke extends EnginePlugin {
  @override
  String get author => developerName;

  @override
  String get channel => invokeChannel;

  @override
  String get description => 'ServiceInvoke';

  @override
  Future<void> onPluginMethodCall(
    EngineMethodCall call,
    EngineResult result,
  ) async {}

  @override
  String get title => 'ServiceInvoke';
}

final class ServiceDelegate extends EnginePlugin {
  @override
  String get author => developerName;

  @override
  String get channel => delegateChannel;

  @override
  String get description => 'ServiceDelegate';

  @override
  Future<void> onPluginMethodCall(
    EngineMethodCall call,
    EngineResult result,
  ) async {}

  @override
  String get title => 'ServiceDelegate';
}
