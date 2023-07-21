/*
 * Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
 * SPDX-License-Identifier: MIT-0
 */

package dev.kxgcayh.amazon.realtime.utils

import dev.kxgcayh.amazon.realtime.AmazonChannelResponse
import dev.kxgcayh.amazon.realtime.constants.ResponseMessage
import dev.kxgcayh.amazon.realtime.observers.AudioVideoObserver
import dev.kxgcayh.amazon.realtime.observers.DataMessageObserver
import dev.kxgcayh.amazon.realtime.observers.RealtimeObserver
import dev.kxgcayh.amazon.realtime.observers.VideoTileObserver
import com.amazonaws.services.chime.sdk.meetings.utils.logger.ConsoleLogger
import com.amazonaws.services.chime.sdk.meetings.audiovideo.AudioVideoFacade
import com.amazonaws.services.chime.sdk.meetings.session.DefaultMeetingSession

object MeetingSessionManager {
    private val meetingSessionlogger: ConsoleLogger = ConsoleLogger()

    lateinit var meetingSession: DefaultMeetingSession
    lateinit var audioVideoObserver: AudioVideoObserver
    lateinit var dataMessageObserver: DataMessageObserver
    lateinit var realtimeObserver: RealtimeObserver
    lateinit var videoTileObserver: VideoTileObserver
    var meetingInitialized: Boolean = false

    fun startMeeting(
        audioVideoObserver: AudioVideoObserver,
        dataMessageObserver: DataMessageObserver,
        realtimeObserver: RealtimeObserver,
        videoTileObserver: VideoTileObserver,
    ): AmazonChannelResponse {
        if (!meetingInitialized) {
            val audioVideo: AudioVideoFacade = meetingSession.audioVideo
            addObservers(
                audioVideoObserver,
                dataMessageObserver,
                realtimeObserver,
                videoTileObserver
            )
            audioVideo.start()
            audioVideo.startRemoteVideo()
            meetingInitialized = true
        }
        return AmazonChannelResponse(true, ResponseMessage.CREATE_MEETING_SUCCESS)
    }

    private fun addObservers(
        audioVideoObserver: AudioVideoObserver,
        dataMessageObserver: DataMessageObserver,
        realtimeObserver: RealtimeObserver,
        videoTileObserver: VideoTileObserver,
    ) {
        val audioVideo: AudioVideoFacade = meetingSession.audioVideo
        audioVideoObserver.let {
            audioVideo.addAudioVideoObserver(it)
            this.audioVideoObserver = audioVideoObserver
            meetingSessionlogger.debug("AudioVideoObserver", "AudioVideoObserver initialized")
        }
        dataMessageObserver.let {
            audioVideo.addRealtimeDataMessageObserver("capabilities", it)
            audioVideo.addRealtimeDataMessageObserver("chat", it)
            this.dataMessageObserver = dataMessageObserver
            meetingSessionlogger.debug("DataMessageObserver", "DataMessageObserver initialized")
        }
        realtimeObserver.let {
            audioVideo.addRealtimeObserver(it)
            this.realtimeObserver = realtimeObserver
            meetingSessionlogger.debug("RealtimeObserver", "RealtimeObserver initialized")
        }
        videoTileObserver.let {
            audioVideo.addVideoTileObserver(videoTileObserver)
            this.videoTileObserver = videoTileObserver
            meetingSessionlogger.debug("VideoTileObserver", "VideoTileObserver initialized")
        }
    }

    private fun removeObservers() {
        audioVideoObserver.let {
            meetingSession.audioVideo.removeAudioVideoObserver(it)
        }
        dataMessageObserver.let {
            meetingSession.audioVideo.removeRealtimeDataMessageObserverFromTopic("capabilities")
            meetingSession.audioVideo.removeRealtimeDataMessageObserverFromTopic("chat")
        }
        realtimeObserver.let {
            meetingSession.audioVideo.removeRealtimeObserver(it)
        }
        videoTileObserver.let {
            meetingSession.audioVideo.removeVideoTileObserver(it)
        }
    }

    fun stop(): AmazonChannelResponse {
        meetingSession.audioVideo.stopRemoteVideo()
        meetingSession.audioVideo.stop()
        removeObservers()
        meetingInitialized = false
        return AmazonChannelResponse(true, ResponseMessage.MEETING_STOPPED_SUCCESSFULLY)
    }

    private val NULL_MEETING_SESSION_RESPONSE: AmazonChannelResponse = AmazonChannelResponse(
        false, ResponseMessage.MEETING_SESSION_IS_NULL
    )
}