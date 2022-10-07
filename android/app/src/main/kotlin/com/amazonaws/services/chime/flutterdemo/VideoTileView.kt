/*
 * Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
 * SPDX-License-Identifier: MIT-0
 */
 
package com.amazonaws.services.chime.flutterdemo

import android.content.Context
import android.view.View
import io.flutter.plugin.platform.PlatformView
import com.amazonaws.services.chime.sdk.meetings.audiovideo.video.DefaultVideoRenderView
import com.amazonaws.services.chime.sdk.meetings.audiovideo.video.VideoScalingType
import com.amazonaws.services.chime.sdk.meetings.utils.logger.ConsoleLogger

internal class VideoTileView(context: Context?, creationParams: Int?) : PlatformView {
    private val view: DefaultVideoRenderView

    private val videoTileViewLogger: ConsoleLogger = ConsoleLogger()

    override fun getView(): View {
        return view
    }

    override fun dispose() {}

    init {
        view = DefaultVideoRenderView(context as Context)
        view.scalingType = VideoScalingType.AspectFit
        MeetingSessionManager.meetingSession?.audioVideo?.bindVideoView(view, creationParams as Int)
            ?: videoTileViewLogger.error("VideoTileView", "Error while binding video view.")
    }
}