import 'package:logger/logger.dart';

final Logger lg = Logger(
  printer: PrettyPrinter(
    methodCount: 1,
    errorMethodCount: 1,
    lineLength: 900,
    colors: true,
    printEmojis: true,
    noBoxingByDefault: true,
    printTime: false,
  ),
);
