/*
 * Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
 * SPDX-License-Identifier: MIT-0
 */

import 'package:flutter/material.dart';
import 'package:flutter_demo_chime_sdk/view_models/join_meeting_view_model.dart';
import 'package:flutter_demo_chime_sdk/view_models/meeting_view_model.dart';
import 'package:flutter_demo_chime_sdk/views/join_meeting.dart';
import 'package:flutter_demo_chime_sdk/views/meeting.dart';
import 'package:provider/provider.dart';

import 'method_channel_coordinator.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => MethodChannelCoordinator()),
        ChangeNotifierProvider(create: (_) => JoinMeetingViewModel()),
        ChangeNotifierProvider(create: (context) => MeetingViewModel(context)),
      ],
      child: GestureDetector(
        onTap: () {
          // Unfocus keyboard when tapping on non-clickable widget
          FocusScopeNode currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus) {
            FocusManager.instance.primaryFocus?.unfocus();
          }
        },
        child: MaterialApp(
          title: 'Amazon Chime SDK Flutter Demo',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          routes: {
            '/joinMeeting': (_) => JoinMeetingView(),
            '/meeting': (_) => const MeetingView(),
          },
          home: JoinMeetingView(),
        ),
      ),
    );
  }
}
