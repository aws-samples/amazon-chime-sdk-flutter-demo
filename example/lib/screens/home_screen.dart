import 'package:aws_chime/aws_chime.dart';
import 'package:aws_chime_example/aws_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final permission = ref.watch(permissionProvider);
    final observer = ref.watch(observerProvider);
    final awsChimeController = ref.watch(awsChimeProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Chime Plugin')),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            await Future.value([
              await permission.audio(),
              await permission.video(),
            ]).then((_) {
              observer.initializeObservers(awsChimeController);
              observer.initializeMethodCallHandler();
              awsChimeController.initializeMeetingData(
                MeetingDataSource(
                  joinInfo: JoinInfoModel(
                    MeetingModel(
                      dotenv.get('MEETING_ID'),
                      dotenv.get('EXTERNAL_MEETING_ID'),
                      dotenv.get('MEDIA_REGION'),
                      MediaPlacementModel(
                        dotenv.get('AUDIO_HOST_URL'),
                        dotenv.get('AUDIO_FALLBACK_URL'),
                        dotenv.get('SIGNALING_URL'),
                        dotenv.get('TURN_CONTROLLER_URL'),
                      ),
                    ),
                    AttendeeInfoModel(
                      dotenv.get('EXTERNAL_USER_ID'),
                      dotenv.get('ATTENDEE_ID'),
                      dotenv.get('JOIN_TOKEN'),
                    ),
                  ),
                ),
              );
              awsChimeController.joinMeeting();
            });
          },
          child: const Text('Join Meeting'),
        ),
      ),
    );
  }
}
