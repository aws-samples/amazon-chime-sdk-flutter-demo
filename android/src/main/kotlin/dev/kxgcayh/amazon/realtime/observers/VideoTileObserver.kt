/*
 * Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
 * SPDX-License-Identifier: MIT-0
 */

package dev.kxgcayh.amazon.realtime.observers

import com.google.gson.Gson
import dev.kxgcayh.amazon.realtime.AmazonChannelCoordinator
import dev.kxgcayh.amazon.realtime.constants.MethodCallFlutter
import dev.kxgcayh.amazon.realtime.utils.MeetingSessionManager
import com.amazonaws.services.chime.sdk.meetings.audiovideo.video.VideoTileState
import com.amazonaws.services.chime.sdk.meetings.audiovideo.video.VideoTileObserver

class VideoTileObserver(val methodChannel: AmazonChannelCoordinator): VideoTileObserver {
    private val gson = Gson()

    override fun onVideoTileAdded(tileState: VideoTileState) {
        methodChannel.callFlutterMethod(
            MethodCallFlutter.VIDEO_TILE_ADD,
            videoTileStateToMap(tileState)
        )
    }

    override fun onVideoTilePaused(tileState: VideoTileState) {
        methodChannel.callFlutterMethod(
            MethodCallFlutter.PAUSE_VIDEO_TILE,
            videoTileStateToMap(tileState)
        )
    }

    override fun onVideoTileRemoved(tileState: VideoTileState) {
        MeetingSessionManager.meetingSession.audioVideo.unbindVideoView(tileState.tileId)
        methodChannel.callFlutterMethod(
            MethodCallFlutter.VIDEO_TILE_REMOVE,
            videoTileStateToMap(tileState)
        )
    }

    override fun onVideoTileResumed(tileState: VideoTileState) {
        methodChannel.callFlutterMethod(
            MethodCallFlutter.RESUME_VIDEO_TILE,
            videoTileStateToMap(tileState)
        )
    }

    override fun onVideoTileSizeChanged(tileState: VideoTileState) {
        // App will not handle size changed
    }

    private fun videoTileStateToMap(state: VideoTileState): String {
        return gson.toJson(mapOf(
            "tileId" to state.tileId,
            "attendeeId" to state.attendeeId,
            "videoStreamContentWidth" to state.videoStreamContentWidth,
            "videoStreamContentHeight" to state.videoStreamContentHeight,
            "isLocalTile" to state.isLocalTile,
            "isContent" to state.isContent,
            "videoPauseState" to state.pauseState.value
        ))
    }
}