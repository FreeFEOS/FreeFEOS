import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';

import '../event/event_buffer.dart';
import '../event/output_event.dart';
import '../type/logger_listener.dart';

final class Log {
  static bool _instanced = false;

  /// 初始化日志
  static void init() {
    Logger.root.level = Level.ALL;
    if (kDebugMode) {
      Log.registerListener(
        (record) => log(
          record.printable(),
          stackTrace: record.stackTrace,
        ),
      );
    }
    Log.registerListener(
      (record) {
        while (EventBuffer.outputEventBuffer.length >= 1000) {
          EventBuffer.outputEventBuffer.removeFirst();
        }
        EventBuffer.outputEventBuffer.add(
          OutputEvent(
            record.level,
            [record.printable()],
          ),
        );
      },
    );
    _instanced = true;
  }

  /// Debug级别
  static void d({
    required String tag,
    required String message,
  }) {
    _printLog(
      tag: tag,
      level: Level.CONFIG,
      message: message,
    );
  }

  /// Info级别
  static void i({
    required String tag,
    required String message,
  }) {
    _printLog(
      tag: tag,
      level: Level.INFO,
      message: message,
    );
  }

  /// Warning级别
  static void w({
    required String tag,
    required String message,
  }) {
    _printLog(
      tag: tag,
      level: Level.WARNING,
      message: message,
    );
  }

  /// Error级别
  static void e({
    required String tag,
    required String message,
    dynamic error,
    StackTrace? stackTrace,
  }) {
    _printLog(
      tag: tag,
      level: Level.SEVERE,
      message: message,
      error: error,
      stackTrace: stackTrace,
    );
  }

  /// 打印日志
  static void _printLog({
    required String tag,
    required Level level,
    required String message,
    dynamic error,
    StackTrace? stackTrace,
  }) {
    if (_instanced) {
      return Logger(tag).log(
        level,
        message,
        error,
        stackTrace,
        null,
      );
    } else {
      return debugPrint(
        'tag: $tag, '
        'message: $message, '
        'error: $error',
      );
    }
  }

  static void registerListener(LoggerListener onRecord) {
    Logger.root.onRecord
        .map((e) => LoggerRecord.fromLogger(e))
        .listen(onRecord);
  }

  static void clearListeners() {
    Logger.root.clearListeners();
  }
}

/// Contains all the information about the [LogRecord]
/// and can be printed with [printable] based on [LoggerRecord]
class LoggerRecord {
  /// Original [LogRecord] from [Logger]
  final LogRecord logRecord;

  /// [Logger] name
  final String loggerName;

  /// Log severity
  final Level level;

  /// Log message
  final String message;

  /// Log time
  final DateTime? time;

  /// [Error] stacktrace
  final StackTrace? stackTrace;

  LoggerRecord._(
    this.logRecord,
    this.loggerName,
    this.message,
    this.level,
    this.time,
    this.stackTrace,
  );

  /// Create a [LoggerRecord] from a [LogRecord]
  factory LoggerRecord.fromLogger(LogRecord record) {
    // Get stacktrace from record stackTrace or record object
    StackTrace? stackTrace = record.stackTrace;
    if (record.stackTrace == null && record.object is Error) {
      stackTrace = (record.object as Error).stackTrace;
    }
    // Get message
    var message = record.message;
    // Maybe add object
    if (record.object != null) message += " - ${record.object}";
    // Build Logger record
    return LoggerRecord._(
      record,
      record.loggerName,
      message,
      record.level,
      record.time,
      stackTrace,
    );
  }

  /// Convert the log to a printable [String]
  String printable() {
    var printedMessage = "";
    if (time != null) {
      printedMessage += "[${time!.toIso8601String()}] ";
    }
    printedMessage += "${_levelShort(level)}/";
    printedMessage += loggerName;
    printedMessage += ': $message';
    return printedMessage;
  }

  static String _levelShort(Level level) {
    if (level == Level.CONFIG) {
      return "D";
    } else if (level == Level.INFO) {
      return "I";
    } else if (level == Level.WARNING) {
      return "W";
    } else if (level == Level.SEVERE) {
      return "E";
    } else {
      return "?";
    }
  }
}

extension LevelExtension on Level {
  Color toColor(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    if (this == Level.CONFIG) {
      return dark ? Colors.white38 : Colors.black38;
    } else if (this == Level.INFO) {
      return dark ? Colors.white : Colors.black;
    } else if (this == Level.WARNING) {
      return Colors.orange;
    } else if (this == Level.SEVERE) {
      return Colors.red;
    } else if (this == Level.SHOUT) {
      return Colors.pinkAccent;
    } else {
      return dark ? Colors.white : Colors.black;
    }
  }
}
