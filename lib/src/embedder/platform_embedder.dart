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
  late FreeFEOSPlatform _linker;
  @override
  String get pluginAuthor => developerName;

  @override
  String get pluginChannel => embedderChannel;

  @override
  String get pluginDescription => '系统与平台通信';

  @override
  String get pluginName => 'PlatformEmbedder';

  @override
  void onCreate() {
    super.onCreate();
    _linker = FreeFEOSLinker();
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
      invoke: () async => List.empty(),
      mobile: (linker) async => await linker.getPlatformPluginList(),
      error: (exception) async {
        return List.empty();
      },
    );
  }

  @override
  Future<bool?> openPlatformDialog() async {
    return await _invoke(
      invoke: () async {},
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
      invoke: () async {},
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
    required Future<dynamic> Function(FreeFEOSPlatform linker) mobile,
    required Future<dynamic> Function(dynamic exception) error,
  }) async {
    if (kIsWebBroser) return invoke.call();
    if (kUseNative) {
      try {
        return await mobile.call(_linker);
      } catch (exception) {
        return await error.call(exception);
      }
    } else {
      try {
        return await invoke.call();
      } catch (exception) {
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
