/*
 * Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
 * SPDX-License-Identifier: MIT-0
 */
 
package com.amazonaws.services.chime.flutterdemo

import com.amazonaws.services.chime.sdk.meetings.audiovideo.video.VideoTileObserver
import com.amazonaws.services.chime.sdk.meetings.audiovideo.video.VideoTileState
import com.amazonaws.services.chime.sdk.meetings.utils.logger.ConsoleLogger

class VideoTileObserver(val methodChannel: MethodChannelCoordinator) : VideoTileObserver {

    private val videoTileObserverLogger: ConsoleLogger = ConsoleLogger()

    override fun onVideoTileAdded(tileState: VideoTileState) {
        methodChannel.callFlutterMethod(MethodCall.videoTileAdd, videoTileStateToMap(tileState))
    }

    override fun onVideoTilePaused(tileState: VideoTileState) {
        // Out of scope
    }

    override fun onVideoTileRemoved(tileState: VideoTileState) {
        MeetingSessionManager.meetingSession?.audioVideo?.unbindVideoView(tileState.tileId)
            ?: videoTileObserverLogger.error(
                "onVideoTileRemoved",
                "Error while unbinding video view."
            )
        methodChannel.callFlutterMethod(MethodCall.videoTileRemove, videoTileStateToMap(tileState))
    }

    override fun onVideoTileResumed(tileState: VideoTileState) {
        // Out of scope
    }

    override fun onVideoTileSizeChanged(tileState: VideoTileState) {
        // Out of scope
    }

    private fun videoTileStateToMap(state: VideoTileState): Map<String, Any?> {
        return mapOf(
            "tileId" to state.tileId,
            "attendeeId" to state.attendeeId,
            "videoStreamContentWidth" to state.videoStreamContentWidth,
            "videoStreamContentHeight" to state.videoStreamContentHeight,
            "isLocalTile" to state.isLocalTile,
            "isContent" to state.isContent
        )
    }
}