import '../plugin/plugin_details.dart';
import '../plugin/plugin_runtime.dart';

typedef PluginGetter = RuntimePlugin? Function(
  PluginDetails details,
);
