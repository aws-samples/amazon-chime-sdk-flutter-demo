import 'package:amazon_realtime/amazon_realtime.dart';
import 'package:amazon_realtime_example/chime_meeting.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class JoinMeetingScreen extends StatefulWidget {
  const JoinMeetingScreen({super.key});

  @override
  State<JoinMeetingScreen> createState() => JoinMeetingScreenState();
}

class JoinMeetingScreenState extends State<JoinMeetingScreen> {
  @override
  void initState() {
    if (!mounted) return;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Amazon Realtime Example'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Join Meeting Simulation'),
            ElevatedButton(
              onPressed: () async {
                // ? You can join the meeting based on ur api
                // final dio = Dio();
                // await dio.get(dotenv.get('JOIN_URI')).then(
                //   (result) {
                //     final response = JoinRoomResponse.fromJson(result.data);
                //     return Navigator.pushReplacement(
                //       context,
                //       MaterialPageRoute(
                //         builder: (context) => ChimeMeeting(
                //           source: MeetingDataSource(meetingInfo: response.data),
                //         ),
                //       ),
                //     );
                //   },
                // );

                // ? Or define data first at environment
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChimeMeeting(
                      source: MeetingDataSource(
                        meetingInfo: MeetingInfo(
                          meeting: MeetingData(
                            meetingId: dotenv.get('MEETING_ID'),
                            externalMeetingId: dotenv.get(
                              'EXTERNAL_MEETING_ID',
                            ),
                            mediaRegion: dotenv.get('MEDIA_REGION'),
                            mediaPlacement: MediaPlacement(
                              audioHostUrl: dotenv.get('AUDIO_HOST_URL'),
                              audioFallbackUrl:
                                  dotenv.get('AUDIO_FALLBACK_URL'),
                              signalingUrl: dotenv.get('SIGNALING_URL'),
                              turnControlUrl: dotenv.get('TURN_CONTROLLER_URL'),
                            ),
                          ),
                          attendee: AttendeeInfo(
                            attendeeId: dotenv.get('ATTENDEE_ID'),
                            externalUserId: dotenv.get('EXTERNAL_USER_ID'),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
              child: Text('JOIN NOW'),
            ),
          ],
        ),
      ),
    );
  }
}
