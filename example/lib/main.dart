import 'package:amazon_realtime_example/join_meeting_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

Future<void> main() async {
  await dotenv.load(fileName: '.env');
  runApp(ProviderScope(child: AmazonRealtimeExample()));
}

class AmazonRealtimeExample extends StatelessWidget {
  const AmazonRealtimeExample({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: JoinMeetingScreen());
  }
}
