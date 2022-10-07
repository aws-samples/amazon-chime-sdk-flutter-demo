/*
 * Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
 * SPDX-License-Identifier: MIT-0
 */

import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_demo_chime_sdk/view_models/meeting_view_model.dart';
import 'package:provider/provider.dart';

class ScreenShare extends StatelessWidget {
  final int? paramsVT;

  const ScreenShare({super.key, required this.paramsVT});

  @override
  Widget build(BuildContext context) {
    MeetingViewModel meetingProvider = Provider.of<MeetingViewModel>(context);

    Widget contentTile;
    Widget body;

    if (Platform.isIOS) {
      contentTile = UiKitView(
        viewType: "videoTile",
        creationParams: paramsVT as int,
        creationParamsCodec: const StandardMessageCodec(),
      );
    } else if (Platform.isAndroid) {
      return PlatformViewLink(
        viewType: 'videoTile',
        surfaceFactory: (BuildContext context, PlatformViewController controller) {
          return AndroidViewSurface(
            controller: controller as AndroidViewController,
            gestureRecognizers: const <Factory<OneSequenceGestureRecognizer>>{},
            hitTestBehavior: PlatformViewHitTestBehavior.opaque,
          );
        },
        onCreatePlatformView: (PlatformViewCreationParams params) {
          final AndroidViewController controller = PlatformViewsService.initExpensiveAndroidView(
            id: params.id,
            viewType: 'videoTile',
            layoutDirection: TextDirection.ltr,
            creationParams: paramsVT,
            creationParamsCodec: const StandardMessageCodec(),
            onFocus: () => params.onFocusChanged,
          );
          controller.addOnPlatformViewCreatedListener(params.onPlatformViewCreated);
          controller.create();
          return controller;
        },
      );
    } else {
      contentTile = const Text("Unrecognized Platform.");
    }

    if (!meetingProvider.isReceivingScreenShare) {
      body = GestureDetector(
        onDoubleTap: () => Navigator.popAndPushNamed(context, "/meeting"),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Center(
              child: Text("Screenshare is no longer active."),
            ),
            Center(
              child: Text(
                "Double tap to go back to meeting.",
                style: TextStyle(color: Colors.grey),
              ),
            ),
          ],
        ),
      );
    } else {
      body = Column(
        children: [
          Expanded(
            child: SizedBox(
              width: double.infinity,
              child: GestureDetector(
                onDoubleTap: () => Navigator.popAndPushNamed(context, "/meeting"),
                child: contentTile,
              ),
            ),
          ),
        ],
      );
    }

    return WillPopScope(
      onWillPop: () async {
        Navigator.popAndPushNamed(context, "/meeting");
        return false;
      },
      child: Scaffold(
        body: body,
      ),
    );
  }
}
