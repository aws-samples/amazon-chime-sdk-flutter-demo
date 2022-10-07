/*
 * Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
 * SPDX-License-Identifier: MIT-0
 */

import 'dart:io' show Platform;
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_demo_chime_sdk/view_models/meeting_view_model.dart';
import 'package:flutter_demo_chime_sdk/views/screenshare.dart';
import 'package:provider/provider.dart';

import '../logger.dart';
import 'style.dart';

class MeetingView extends StatelessWidget {
  const MeetingView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final meetingProvider = Provider.of<MeetingViewModel>(context);
    final orientation = MediaQuery.of(context).orientation;

    if (!meetingProvider.isMeetingActive) {
      Navigator.maybePop(context);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("${meetingProvider.meetingId}"),
        automaticallyImplyLeading: false,
      ),
      resizeToAvoidBottomInset: true,
      body: meetingBody(orientation, meetingProvider, context),
    );
  }

  //
  // —————————————————————————— Main Body ——————————————————————————————————————
  //

  Widget meetingBody(Orientation orientation, MeetingViewModel meetingProvider, BuildContext context) {
    if (orientation == Orientation.portrait) {
      return meetingBodyPortrait(meetingProvider, orientation, context);
    } else {
      return meetingBodyLandscape(meetingProvider, orientation, context);
    }
  }

  //
  // —————————————————————————— Portrait Body ——————————————————————————————————————
  //

  Widget meetingBodyPortrait(MeetingViewModel meetingProvider, Orientation orientation, BuildContext context) {
    return Center(
      child: Column(
        children: [
          const SizedBox(
            height: 8,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: displayVideoTiles(meetingProvider, orientation, context),
          ),
          const Padding(
            padding: EdgeInsets.only(top: 30, bottom: 20),
            child: Text(
              "Attendees",
              style: TextStyle(fontSize: Style.titleSize),
              textAlign: TextAlign.center,
            ),
          ),
          Column(
            children: displayAttendees(meetingProvider, context),
          ),
          WillPopScope(
            onWillPop: () async {
              meetingProvider.stopMeeting();
              return true;
            },
            child: const Spacer(),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 50),
            child: SizedBox(
              height: 50,
              width: 300,
              child: leaveMeetingButton(meetingProvider, context),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> displayAttendees(MeetingViewModel meetingProvider, BuildContext context) {
    List<Widget> attendees = [];
    if (meetingProvider.currAttendees.containsKey(meetingProvider.localAttendeeId)) {
      attendees.add(localListInfo(meetingProvider, context));
    }
    if (meetingProvider.currAttendees.length > 1) {
      if (meetingProvider.currAttendees.containsKey(meetingProvider.remoteAttendeeId)) {
        attendees.add(remoteListInfo(meetingProvider));
      }
    }

    return attendees;
  }

  Widget localListInfo(MeetingViewModel meetingProvider, BuildContext context) {
    return ListTile(
      title: Text(
        meetingProvider.formatExternalUserId(meetingProvider.currAttendees[meetingProvider.localAttendeeId]?.externalUserId),
        style: const TextStyle(
          color: Colors.black,
          fontSize: Style.fontSize,
        ),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.headphones),
            iconSize: Style.iconSize,
            color: Colors.blue,
            onPressed: () {
              showAudioDeviceDialog(meetingProvider, context);
            },
          ),
          IconButton(
            icon: Icon(localMuteIcon(meetingProvider)),
            iconSize: Style.iconSize,
            padding: EdgeInsets.symmetric(horizontal: Style.iconPadding),
            color: Colors.blue,
            onPressed: () {
              meetingProvider.sendLocalMuteToggle();
            },
          ),
          IconButton(
            icon: Icon(localVideoIcon(meetingProvider)),
            iconSize: Style.iconSize,
            padding: EdgeInsets.symmetric(horizontal: Style.iconPadding),
            constraints: const BoxConstraints(),
            color: Colors.blue,
            onPressed: () {
              meetingProvider.sendLocalVideoTileOn();
            },
          ),
        ],
      ),
    );
  }

  Widget remoteListInfo(MeetingViewModel meetingProvider) {
    return (ListTile(
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: Style.iconPadding),
            child: Icon(
              remoteMuteIcon(meetingProvider),
              size: Style.iconSize,
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: Style.iconPadding),
            child: Icon(
              remoteVideoIcon(meetingProvider),
              size: Style.iconSize,
            ),
          ),
        ],
      ),
      title: Text(
        meetingProvider.formatExternalUserId(meetingProvider.currAttendees[meetingProvider.remoteAttendeeId]?.externalUserId),
        style: const TextStyle(fontSize: Style.fontSize),
      ),
    ));
  }

  //
  // —————————————————————————— Landscape Body ——————————————————————————————————————
  //

  Widget meetingBodyLandscape(MeetingViewModel meetingProvider, Orientation orientation, BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: displayVideoTiles(meetingProvider, orientation, context),
          ),
        ),
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 20,
              ),
              const Text(
                "Attendees",
                style: TextStyle(fontSize: Style.titleSize),
              ),
              Column(
                children: displayAttendeesLanscape(meetingProvider, context),
              ),
              WillPopScope(
                onWillPop: () async {
                  meetingProvider.stopMeeting();
                  return true;
                },
                child: const Spacer(),
              ),
              leaveMeetingButton(meetingProvider, context),
              const SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ],
    );
  }

  List<Widget> displayAttendeesLanscape(MeetingViewModel meetingProvider, BuildContext context) {
    List<Widget> attendees = [];
    if (meetingProvider.currAttendees.containsKey(meetingProvider.localAttendeeId)) {
      attendees.add(localListInfoLandscape(meetingProvider, context));
    }
    if (meetingProvider.currAttendees.length > 1) {
      if (meetingProvider.currAttendees.containsKey(meetingProvider.remoteAttendeeId)) {
        attendees.add(remoteListInfoLandscape(meetingProvider));
      }
    }

    return attendees;
  }

  Widget localListInfoLandscape(MeetingViewModel meetingProvider, BuildContext context) {
    return SizedBox(
      width: 500,
      child: ListTile(
        title: Text(
          meetingProvider.formatExternalUserId(meetingProvider.currAttendees[meetingProvider.localAttendeeId]?.externalUserId),
          style: const TextStyle(
            color: Colors.black,
            fontSize: Style.fontSize,
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.headphones),
              iconSize: Style.iconSize,
              color: Colors.blue,
              onPressed: () {
                showAudioDeviceDialog(meetingProvider, context);
              },
            ),
            IconButton(
              icon: Icon(localMuteIcon(meetingProvider)),
              iconSize: Style.iconSize,
              padding: EdgeInsets.symmetric(horizontal: Style.iconPadding),
              color: Colors.blue,
              onPressed: () {
                meetingProvider.sendLocalMuteToggle();
              },
            ),
            IconButton(
              icon: Icon(localVideoIcon(meetingProvider)),
              iconSize: Style.iconSize,
              padding: EdgeInsets.symmetric(horizontal: Style.iconPadding),
              constraints: const BoxConstraints(),
              color: Colors.blue,
              onPressed: () {
                meetingProvider.sendLocalVideoTileOn();
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget remoteListInfoLandscape(MeetingViewModel meetingProvider) {
    return SizedBox(
      width: 500,
      child: ListTile(
        title: Text(
          meetingProvider.formatExternalUserId(meetingProvider.currAttendees[meetingProvider.remoteAttendeeId]?.externalUserId),
          style: const TextStyle(
            color: Colors.black,
            fontSize: Style.fontSize,
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: Style.iconPadding),
              child: Icon(
                remoteMuteIcon(meetingProvider),
                size: Style.iconSize,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: Style.iconPadding),
              child: Icon(
                remoteVideoIcon(meetingProvider),
                size: Style.iconSize,
              ),
            ),
          ],
        ),
      ),
    );
  }

  //
  // —————————————————————————— Helpers ——————————————————————————————————————
  //

  void openFullscreenDialog(BuildContext context, int? params, MeetingViewModel meetingProvider) {
    Widget contentTile;

    if (Platform.isIOS) {
      contentTile = UiKitView(
        viewType: "videoTile",
        creationParams: params,
        creationParamsCodec: const StandardMessageCodec(),
      );
    } else if (Platform.isAndroid) {
      contentTile = PlatformViewLink(
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
            creationParams: params,
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
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const MeetingView()));
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) {
          return Scaffold(
            body: Column(
              children: [
                Expanded(
                  child: SizedBox(
                    width: double.infinity,
                    child: GestureDetector(
                        onDoubleTap: () =>
                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const MeetingView())),
                        child: contentTile),
                  ),
                ),
              ],
            ),
          );
        },
        fullscreenDialog: true,
      ),
    );
  }

  List<Widget> displayVideoTiles(MeetingViewModel meetingProvider, Orientation orientation, BuildContext context) {
    Widget screenShareWidget = Expanded(child: videoTile(meetingProvider, context, isLocal: false, isContent: true));
    Widget localVideoTile = videoTile(meetingProvider, context, isLocal: true, isContent: false);
    Widget remoteVideoTile = videoTile(meetingProvider, context, isLocal: false, isContent: false);

    if (meetingProvider.currAttendees.containsKey(meetingProvider.contentAttendeeId)) {
      if (meetingProvider.isReceivingScreenShare) {
        return [screenShareWidget];
      }
    }

    List<Widget> videoTiles = [];

    if (meetingProvider.currAttendees[meetingProvider.localAttendeeId]?.isVideoOn ?? false) {
      if (meetingProvider.currAttendees[meetingProvider.localAttendeeId]?.videoTile != null) {
        videoTiles.add(localVideoTile);
      }
    }
    if (meetingProvider.currAttendees.length > 1) {
      if (meetingProvider.currAttendees.containsKey(meetingProvider.remoteAttendeeId)) {
        if ((meetingProvider.currAttendees[meetingProvider.remoteAttendeeId]?.isVideoOn ?? false) &&
            meetingProvider.currAttendees[meetingProvider.remoteAttendeeId]?.videoTile != null) {
          videoTiles.add(Expanded(child: remoteVideoTile));
        }
      }
    }

    if (videoTiles.isEmpty) {
      const Widget emptyVideos = Text("No video detected");
      if (orientation == Orientation.portrait) {
        videoTiles.add(
          emptyVideos,
        );
      } else {
        videoTiles.add(
          const Center(
            widthFactor: 2.5,
            child: emptyVideos,
          ),
        );
      }
    }

    return videoTiles;
  }

  Widget contentVideoTile(int? paramsVT, MeetingViewModel meetingProvider, BuildContext context) {
    Widget videoTile;
    if (Platform.isIOS) {
      videoTile = UiKitView(
        viewType: "videoTile",
        creationParams: paramsVT,
        creationParamsCodec: const StandardMessageCodec(),
      );
    } else if (Platform.isAndroid) {
      videoTile = PlatformViewLink(
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
      videoTile = const Text("Unrecognized Platform.");
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: SizedBox(
        width: 200,
        height: 230,
        child: GestureDetector(
          onDoubleTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => ScreenShare(paramsVT: paramsVT)));
          },
          child: videoTile,
        ),
      ),
    );
  }

  Widget videoTile(MeetingViewModel meetingProvider, BuildContext context, {required bool isLocal, required bool isContent}) {
    int? paramsVT;

    if (isContent) {
      if (meetingProvider.contentAttendeeId != null) {
        if (meetingProvider.currAttendees[meetingProvider.contentAttendeeId]?.videoTile != null) {
          paramsVT = meetingProvider.currAttendees[meetingProvider.contentAttendeeId]?.videoTile?.tileId as int;
          return contentVideoTile(paramsVT, meetingProvider, context);
        }
      }
    } else if (isLocal) {
      paramsVT = meetingProvider.currAttendees[meetingProvider.localAttendeeId]?.videoTile?.tileId;
    } else {
      paramsVT = meetingProvider.currAttendees[meetingProvider.remoteAttendeeId]?.videoTile?.tileId;
    }

    Widget videoTile;
    if (Platform.isIOS) {
      videoTile = UiKitView(
        viewType: "videoTile",
        creationParams: paramsVT,
        creationParamsCodec: const StandardMessageCodec(),
      );
    } else if (Platform.isAndroid) {
      videoTile = PlatformViewLink(
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
          );
          controller.addOnPlatformViewCreatedListener(params.onPlatformViewCreated);
          controller.create();
          return controller;
        },
      );
    } else {
      videoTile = const Text("Unrecognized Platform.");
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: SizedBox(
        width: 200,
        height: 230,
        child: videoTile,
      ),
    );
  }

  void showAudioDeviceDialog(MeetingViewModel meetingProvider, BuildContext context) async {
    String? device = await showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            title: const Text("Choose Audio Device"),
            elevation: 40,
            titleTextStyle: const TextStyle(color: Colors.black, fontSize: Style.fontSize, fontWeight: FontWeight.bold),
            backgroundColor: Colors.white,
            children: getSimpleDialogOptionsAudioDevices(meetingProvider, context),
          );
        });
    if (device == null) {
      logger.w("No device chosen.");
      return;
    }

    meetingProvider.updateCurrentDevice(device);
  }

  List<Widget> getSimpleDialogOptionsAudioDevices(MeetingViewModel meetingProvider, BuildContext context) {
    List<Widget> dialogOptions = [];
    FontWeight weight;
    for (var i = 0; i < meetingProvider.deviceList.length; i++) {
      if (meetingProvider.deviceList[i] == meetingProvider.selectedAudioDevice) {
        weight = FontWeight.bold;
      } else {
        weight = FontWeight.normal;
      }
      dialogOptions.add(
        SimpleDialogOption(
          child: Text(
            meetingProvider.deviceList[i] as String,
            style: TextStyle(color: Colors.black, fontWeight: weight),
          ),
          onPressed: () {
            logger.i("${meetingProvider.deviceList[i]} was chosen.");
            Navigator.pop(context, meetingProvider.deviceList[i]);
          },
        ),
      );
    }
    return dialogOptions;
  }

  Widget leaveMeetingButton(MeetingViewModel meetingProvider, BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(primary: Colors.red),
      onPressed: () {
        meetingProvider.stopMeeting();
        Navigator.pop(context);
      },
      child: const Text("Leave Meeting"),
    );
  }

  IconData localMuteIcon(MeetingViewModel meetingProvider) {
    if (!meetingProvider.currAttendees[meetingProvider.localAttendeeId]!.muteStatus) {
      return Icons.mic;
    } else {
      return Icons.mic_off;
    }
  }

  IconData remoteMuteIcon(MeetingViewModel meetingProvider) {
    if (!meetingProvider.currAttendees[meetingProvider.remoteAttendeeId]!.muteStatus) {
      return Icons.mic;
    } else {
      return Icons.mic_off;
    }
  }

  IconData localVideoIcon(MeetingViewModel meetingProvider) {
    if (meetingProvider.currAttendees[meetingProvider.localAttendeeId]!.isVideoOn) {
      return Icons.videocam;
    } else {
      return Icons.videocam_off;
    }
  }

  IconData remoteVideoIcon(MeetingViewModel meetingProvider) {
    if (meetingProvider.currAttendees[meetingProvider.remoteAttendeeId]!.isVideoOn) {
      return Icons.videocam;
    } else {
      return Icons.videocam_off;
    }
  }
}
