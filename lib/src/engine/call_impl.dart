import 'method_call.dart';

final class CallImport implements EngineMethodCall {
  const CallImport({
    required this.callMethod,
    required this.callArguments,
  });

  final String? callMethod;
  final dynamic callArguments;

  @override
  String? get method => callMethod;

  @override
  dynamic get arguments => callArguments;
}
