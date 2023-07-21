import 'package:amazon_realtime/src/models/data_message/data_message.dart';

abstract class DataMessageObserverInterface {
  /// Handles data message being received.
  Future<void> dataMessageReceived(DataMessage dataMessage);
}
