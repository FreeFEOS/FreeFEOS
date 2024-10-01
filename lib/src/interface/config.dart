import '../type/types.dart';

final class SystemConfig {
  const SystemConfig({
    required this.enabled,
    required this.developer,
    required this.description,
    required this.official,
    required this.feedback,
  });

  /// 是否启用freefeos
  final bool? enabled;

  /// 开发者
  final String? developer;

  /// 应用的简介
  final String? description;

  /// 官方网站
  final Uri? official;

  /// 用户反馈问题的网站
  final Uri? feedback;
}

final class SystemImport {
  const SystemImport({
    required this.runner,
    required this.plugins,
    required this.initApi,
  });

  final AppRunner? runner;
  final PluginList? plugins;
  final ApiBuilder? initApi;
}
