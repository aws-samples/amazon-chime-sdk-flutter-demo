import 'dart:io';

import 'package:amazon_realtime/amazon_realtime.dart';
import 'package:amazon_realtime_example/join_meeting_screen.dart';
import 'package:bottom_sheet/bottom_sheet.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

class ChimeMeeting extends StatefulWidget {
  const ChimeMeeting({super.key, required this.source});
  final MeetingDataSource source;

  @override
  State<ChimeMeeting> createState() => _ChimeMeetingState();
}

class _ChimeMeetingState extends State<ChimeMeeting> {
  final chimeController = ChimeController();

  @override
  void initState() {
    chimeController.addListener(() => setState(() {}));
    chimeController.setupDataSource(widget.source);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        chimeController.stopCurrentMeeting();
        return true;
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          centerTitle: true,
          title: Text('Live'),
          backgroundColor: Color(0xFF151515),
          leading: IconButton(
            onPressed: () async {
              await showFlexibleBottomSheet(
                minHeight: 0,
                initHeight: 0.8,
                maxHeight: 0.8,
                bottomSheetColor: Colors.transparent,
                context: context,
                builder: (
                  BuildContext context,
                  ScrollController scrollController,
                  double bottomOffset,
                ) {
                  return _SelectMediaDeviceDialog(
                    scrollController: scrollController,
                    devices: chimeController.mediaDevices,
                    selected: chimeController.selectedMediaDevice,
                    onTap: (device) async {
                      chimeController
                          .updateAudioDevice(device)
                          .then((_) => Navigator.pop(context));
                    },
                  );
                },
                isExpand: false,
              );
            },
            icon: Icon(Icons.volume_up_rounded),
          ),
          actions: [
            Icon(
              chimeController.localAttendee?.signalStrength ==
                      SignalStrength.none
                  ? Icons.signal_cellular_alt_1_bar_rounded
                  : chimeController.localAttendee?.signalStrength ==
                          SignalStrength.low
                      ? Icons.signal_cellular_alt_2_bar_rounded
                      : Icons.signal_cellular_alt_rounded,
              color: chimeController.localAttendee?.signalStrength ==
                      SignalStrength.none
                  ? Colors.red
                  : chimeController.localAttendee?.signalStrength ==
                          SignalStrength.low
                      ? Colors.yellow
                      : Colors.green,
            ),
            IconButton(
              onPressed: () async {
                await chimeController.stopCurrentMeeting().then((_) {
                  return Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => JoinMeetingScreen(),
                    ),
                  );
                });
              },
              icon: Icon(Icons.logout),
            )
          ],
        ),
        body: Stack(
          children: [
            if (chimeController.localAttendee != null ||
                chimeController.localVideoTile?.tileId != null)
              Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 10,
                  ),
                  child: Container(
                    height: MediaQuery.of(context).size.height / 4.5,
                    width: MediaQuery.of(context).size.width / 3,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.white.withOpacity(0.25),
                      ),
                      color: Color(0xFF151515),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: chimeController.localVideoTile?.tileId != null
                        ? LayoutBuilder(
                            builder: (context, constraints) {
                              return _VideoTile(
                                size: Size(
                                  constraints.maxWidth,
                                  constraints.maxHeight,
                                ),
                                creationParams:
                                    chimeController.localVideoTile!.tileId,
                              );
                            },
                          )
                        : Icon(
                            Icons.account_circle_rounded,
                            color: Colors.grey,
                            size: 85,
                          ),
                  ),
                ),
              ),
            if (chimeController.highlighted != null)
              Align(
                alignment: Alignment.center,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height / 3.5,
                        decoration: BoxDecoration(
                          color: Color(0xFF151515),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.25),
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: chimeController.highlighted?.videoTile != null
                            ? LayoutBuilder(builder: (context, constraints) {
                                return _VideoTile(
                                  size: Size(
                                    constraints.maxWidth,
                                    constraints.maxHeight,
                                  ),
                                  creationParams: chimeController
                                      .highlighted!.videoTile!.tileId,
                                );
                              })
                            : Icon(
                                Icons.account_circle_rounded,
                                color: Colors.grey,
                                size: 120,
                              ),
                      ),
                      Text(
                        chimeController.highlighted?.attendeeInfo.attendeeId ??
                            'Unknown',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              )
          ],
        ),
        bottomNavigationBar: Container(
          height: MediaQuery.of(context).size.height / 11,
          decoration: BoxDecoration(
            color: Color(0xFF151515),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _BottomMenuItem(
                icon: chimeController.localAttendee?.volumeLevel ==
                        VolumeLevel.muted
                    ? Icons.mic_off_rounded
                    : Icons.mic_rounded,
                label: 'Mute',
                iconColor: chimeController.localAttendee?.volumeLevel ==
                            VolumeLevel.muted ||
                        chimeController.localAttendee?.volumeLevel ==
                            VolumeLevel.notSpeaking
                    ? Colors.white
                    : Colors.green,
                onTap: () async {
                  if (chimeController.localAttendee?.volumeLevel !=
                      VolumeLevel.muted) {
                    chimeController.mute();
                  } else {
                    chimeController.unmute();
                  }
                },
              ),
              _BottomMenuItem(
                icon: chimeController.localAttendee?.isVideoOn ?? false
                    ? Icons.videocam_rounded
                    : Icons.videocam_off_rounded,
                label: 'Start Video',
                onTap: () => chimeController.updateLocalVideo(),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 14, horizontal: 12),
                child: Container(
                  width: 1,
                  height: MediaQuery.of(context).size.height,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white),
                  ),
                ),
              ),
              _BottomMenuItem(
                icon: Icons.people_alt_rounded,
                label: 'Participants',
                count: chimeController.attendees.length,
                onTap: () {},
              ),
              _BottomMenuItem(
                icon: Icons.chat_bubble_rounded,
                label: 'Chat',
                onTap: () {},
              ),
              _BottomMenuItem(
                icon: Icons.more_horiz_rounded,
                label: 'More',
                onTap: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BottomMenuItem extends StatelessWidget {
  const _BottomMenuItem({
    this.onTap,
    required this.icon,
    required this.label,
    this.iconColor,
    this.count,
  });

  final void Function()? onTap;
  final IconData icon;
  final String label;
  final Color? iconColor;
  final int? count;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(vertical: 14, horizontal: 12),
            child: Stack(
              alignment: Alignment.topRight,
              children: [
                Column(
                  children: [
                    Icon(
                      icon,
                      color: iconColor ?? Colors.white,
                    ),
                    SizedBox(height: 4),
                    Text(
                      label,
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    )
                  ],
                ),
                if (count != null)
                  Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(20 / 2),
                      border: Border.all(
                        color: Color(0xFF151515),
                        width: 2,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        '$count',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SelectMediaDeviceDialog extends StatelessWidget {
  const _SelectMediaDeviceDialog({
    required this.scrollController,
    required this.devices,
    required this.onTap,
    this.selected,
  });

  final ScrollController scrollController;
  final List<MediaDevice> devices;
  final void Function(MediaDevice media) onTap;
  final MediaDevice? selected;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(
            offset: Offset(0, 2),
            blurRadius: 3,
            color: Colors.black,
          )
        ],
      ),
      child: ListView.builder(
        controller: scrollController,
        shrinkWrap: true,
        itemCount: devices.length,
        itemBuilder: (context, index) {
          final media = devices[index];
          return Material(
            color: Colors.transparent,
            borderRadius: index == 0
                ? BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  )
                : null,
            child: InkWell(
              onTap: () => onTap(media),
              borderRadius: index == 0
                  ? BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    )
                  : null,
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            media.type.toShortString(),
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            media.label,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (selected == media) Icon(Icons.check_rounded),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _VideoTile extends StatelessWidget {
  const _VideoTile({
    required this.creationParams,
    this.size,
  });
  final int creationParams;
  final Size? size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size?.width ?? 165,
      height: size?.height ?? 165,
      child: Platform.isAndroid
          ? PlatformViewLink(
              viewType: 'videoTile',
              surfaceFactory: buildSurfaceFactory,
              onCreatePlatformView: onCreatePlatformView,
            )
          : UiKitView(
              viewType: 'videoTile',
              creationParams: creationParams,
              creationParamsCodec: const StandardMessageCodec(),
            ),
    );
  }

  Widget buildSurfaceFactory(
    BuildContext context,
    PlatformViewController controller,
  ) {
    return AndroidViewSurface(
      controller: controller as AndroidViewController,
      gestureRecognizers: const <Factory<OneSequenceGestureRecognizer>>{},
      hitTestBehavior: PlatformViewHitTestBehavior.opaque,
    );
  }

  PlatformViewController onCreatePlatformView(
    PlatformViewCreationParams params,
  ) {
    late final AndroidViewController platformControl;
    platformControl = PlatformViewsService.initExpensiveAndroidView(
      id: params.id,
      viewType: 'videoTile',
      layoutDirection: TextDirection.rtl,
      creationParams: creationParams,
      creationParamsCodec: const StandardMessageCodec(),
    );

    platformControl.addOnPlatformViewCreatedListener(
      params.onPlatformViewCreated,
    );
    platformControl.create();
    return platformControl;
  }
}
