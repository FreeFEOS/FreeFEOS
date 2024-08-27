/// 入口用
typedef MethodExecer = Future<dynamic> Function(
  String channel,
  String method, [
  dynamic arguments,
]);
