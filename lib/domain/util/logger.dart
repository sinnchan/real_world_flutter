import 'package:logger/logger.dart';

/// simple logger
final sLogger = Logger(
  printer: SimplePrinter(printTime: true),
);

/// pretty logger
final pLogger = Logger(
  printer: PrettyPrinter(printTime: true),
);

