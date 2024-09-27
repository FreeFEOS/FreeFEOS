import 'package:flutter/widgets.dart';
import 'package:freefeos/src/utils/utils.dart';

import '../engine/method_call.dart';
import '../engine/plugin_engine.dart';
import '../engine/result.dart';
import '../framework/service.dart';
import '../framework/want.dart';
import '../interface/platform_interface.dart';
import '../platform/freefeos.dart';
import '../plugin/plugin_runtime.dart';
import '../values/channel.dart';
import '../values/strings.dart';
import 'embedder_binder.dart';

final class PlatformEmbedder extends Service
    implements RuntimePlugin, FreeFEOSPlatform {
  late FreeFEOSPlatform _linker;
  @override
  String get pluginAuthor => developerName;

  @override
  String get pluginChannel => embedderChannel;

  @override
  String get pluginDescription => embedderDescription;

  @override
  String get pluginName => embedderName;

  @override
  void onCreate() {
    super.onCreate();
    _linker = FreeFEOSLinker();
  }

  @override
  IBinder onBind(Want want) {
    return EmbedderBinder(
      embedder: this,
    );
  }

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
    if (PlatformUtil.kIsWebBrowser) return invoke();
    if (PlatformUtil.kUseNative) {
      try {
        return await mobile(_linker);
      } catch (exception) {
        return await error(exception);
      }
    } else {
      try {
        return await invoke();
      } catch (exception) {
        return await error(exception);
      }
    }
  }
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
  String get description => invokeDescription;

  @override
  Future<void> onPluginMethodCall(
    EngineMethodCall call,
    EngineResult result,
  ) async {}

  @override
  String get title => invokeTitle;
}

final class ServiceDelegate extends EnginePlugin {
  @override
  String get author => developerName;

  @override
  String get channel => delegateChannel;

  @override
  String get description => delegateDescription;

  @override
  Future<void> onPluginMethodCall(
    EngineMethodCall call,
    EngineResult result,
  ) async {}

  @override
  String get title => delegateTitle;
}
