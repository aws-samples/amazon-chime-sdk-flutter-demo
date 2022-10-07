/*
 * Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
 * SPDX-License-Identifier: MIT-0
 */

import 'package:flutter/material.dart';
import 'package:flutter_demo_chime_sdk/method_channel_coordinator.dart';
import 'package:provider/provider.dart';

import '../view_models/join_meeting_view_model.dart';
import '../view_models/meeting_view_model.dart';
import 'meeting.dart';

class JoinMeetingView extends StatelessWidget {
  JoinMeetingView({Key? key}) : super(key: key);

  final TextEditingController meetingIdTEC = TextEditingController();
  final TextEditingController attendeeIdTEC = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final joinMeetingProvider = Provider.of<JoinMeetingViewModel>(context);
    final methodChannelProvider = Provider.of<MethodChannelCoordinator>(context);
    final meetingProvider = Provider.of<MeetingViewModel>(context);

    final orientation = MediaQuery.of(context).orientation;

    return joinMeetingBody(joinMeetingProvider, methodChannelProvider, meetingProvider, context, orientation);
  }

//
// —————————————————————————— Main Body ——————————————————————————————————————
//

  Widget joinMeetingBody(JoinMeetingViewModel joinMeetingProvider, MethodChannelCoordinator methodChannelProvider,
      MeetingViewModel meetingProvider, BuildContext context, Orientation orientation) {
    if (orientation == Orientation.portrait) {
      return joinMeetingBodyPortrait(joinMeetingProvider, methodChannelProvider, meetingProvider, context);
    } else {
      return joinMeetingBodyLandscape(joinMeetingProvider, methodChannelProvider, meetingProvider, context);
    }
  }

//
// —————————————————————————— Portrait Body ——————————————————————————————————————
//

  Widget joinMeetingBodyPortrait(JoinMeetingViewModel joinMeetingProvider, MethodChannelCoordinator methodChannelProvider,
      MeetingViewModel meetingProvider, BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Amazon Chime SDK'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            titleFlutterDemo(5),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 10),
              child: meetingTextField(meetingIdTEC),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              child: attendeeTextField(attendeeIdTEC),
            ),
            joinButton(joinMeetingProvider, methodChannelProvider, meetingProvider, context),
            loadingIcon(joinMeetingProvider),
            errorMessage(joinMeetingProvider),
          ],
        ),
      ),
    );
  }

//
// —————————————————————————— Landscape Body ——————————————————————————————————————
//

  Widget joinMeetingBodyLandscape(JoinMeetingViewModel joinMeetingProvider, MethodChannelCoordinator methodChannelProvider,
      MeetingViewModel meetingProvider, BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                height: 60,
              ),
              titleFlutterDemo(10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 10),
                child: meetingTextField(meetingIdTEC),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 16),
                child: attendeeTextField(attendeeIdTEC),
              ),
              joinButton(joinMeetingProvider, methodChannelProvider, meetingProvider, context),
              loadingIcon(joinMeetingProvider),
              errorMessage(joinMeetingProvider),
            ],
          ),
        ),
      ),
    );
  }

//
// —————————————————————————— Helpers ——————————————————————————————————————
//

  Widget joinButton(JoinMeetingViewModel joinMeetingProvider, MethodChannelCoordinator methodChannelProvider,
      MeetingViewModel meetingProvider, BuildContext context) {
    return ElevatedButton(
      child: const Text("Join Meeting"),
      onPressed: () async {
        if (!joinMeetingProvider.joinButtonClicked) {
          // Prevent multiple clicks
          joinMeetingProvider.joinButtonClicked = true;

          // Hide Keyboard
          FocusManager.instance.primaryFocus?.unfocus();

          String meeetingId = meetingIdTEC.text.trim();
          String attendeeId = attendeeIdTEC.text.trim();

          if (joinMeetingProvider.verifyParameters(meeetingId, attendeeId)) {
            // Observers should be initialized before MethodCallHandler
            methodChannelProvider.initializeObservers(meetingProvider);
            methodChannelProvider.initializeMethodCallHandler();

            // Call api, format to JSON and send to native
            bool isMeetingJoined =
                await joinMeetingProvider.joinMeeting(meetingProvider, methodChannelProvider, meeetingId, attendeeId);
            if (isMeetingJoined) {
              // ignore: use_build_context_synchronously
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const MeetingView(),
                ),
              );
            }
          }
          joinMeetingProvider.joinButtonClicked = false;
        }
      },
    );
  }

  Widget titleFlutterDemo(double pad) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: pad),
      child: const Text(
        "Flutter Demo",
        style: TextStyle(
          fontSize: 32,
          color: Colors.blue,
        ),
      ),
    );
  }

  Widget meetingTextField(meetingIdTEC) {
    return TextField(
      controller: meetingIdTEC,
      decoration: const InputDecoration(
        labelText: "Meeting ID",
        border: OutlineInputBorder(),
      ),
    );
  }

  Widget attendeeTextField(attendeeIdTEC) {
    return TextField(
      controller: attendeeIdTEC,
      decoration: const InputDecoration(
        labelText: "Attendee Name",
        border: OutlineInputBorder(),
      ),
    );
  }

  Widget loadingIcon(JoinMeetingViewModel joinMeetingProvider) {
    if (joinMeetingProvider.loadingStatus) {
      return const Padding(padding: EdgeInsets.symmetric(vertical: 10), child: CircularProgressIndicator());
    } else {
      return const SizedBox.shrink();
    }
  }

  Widget errorMessage(JoinMeetingViewModel joinMeetingProvider) {
    if (joinMeetingProvider.error) {
      return SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Text(
              "${joinMeetingProvider.errorMessage}",
              style: const TextStyle(color: Colors.red),
            ),
          ),
        ),
      );
    } else {
      return const SizedBox.shrink();
    }
  }
}
