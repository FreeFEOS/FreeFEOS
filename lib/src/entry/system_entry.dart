import 'package:flutter/widgets.dart';

import '../base/base.dart';
import '../interface/config.dart';
import '../interface/system_interface.dart';

final class SystemEntry extends FreeFEOSInterface with BaseEntry {
  SystemEntry();

  /// 入口函数
  @override
  Future<void> runFreeFEOSApp({
    required SystemImport import,
    required SystemConfig config,
    required Widget app,
    required dynamic error,
  }) async {
    return await () async {
      try {
        return await interface.runFreeFEOSApp(
          import: import,
          config: config,
          app: app,
          error: error,
        );
      } catch (exception) {
        return await super.runFreeFEOSApp(
          import: import,
          config: config,
          app: app,
          error: exception,
        );
      }
    }();
  }
}
