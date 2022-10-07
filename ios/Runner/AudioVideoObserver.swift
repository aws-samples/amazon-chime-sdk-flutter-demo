/*
 * Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
 * SPDX-License-Identifier: MIT-0
 */
 
import AmazonChimeSDK
import AmazonChimeSDKMedia
import Foundation

class MyAudioVideoObserver: AudioVideoObserver {
    
    weak var methodChannel: MethodChannelCoordinator?
    
    init(withMethodChannel methodChannel: MethodChannelCoordinator) {
        self.methodChannel = methodChannel
    }
    
    func audioSessionDidStartConnecting(reconnecting: Bool) {
        // Out of scope
    }
    
    func audioSessionDidStart(reconnecting: Bool) {
        // Out of scope
    }
    
    func audioSessionDidDrop() {
        MeetingSession.shared.meetingSession?.logger.info(msg: "Meeting session dropped")
        methodChannel?.stopAudioVideoFacadeObservers()
    }
    
    func audioSessionDidStopWithStatus(sessionStatus: MeetingSessionStatus) {
        methodChannel?.stopAudioVideoFacadeObservers()
        MeetingSession.shared.meetingSession?.logger.info(msg: "Meeting session stopped with status \(sessionStatus.description)")
        methodChannel?.callFlutterMethod(method: .audioSessionDidStop, args: nil)
    }
    
    func audioSessionDidCancelReconnect() {
        // Out of scope
    }
    
    func connectionDidRecover() {
        // Out of scope
    }
    
    func connectionDidBecomePoor() {
        // Out of scope
    }
    
    func videoSessionDidStartConnecting() {
        MeetingSession.shared.meetingSession?.logger.info(msg: "VideoSession started connecting...")
    }
    
    func videoSessionDidStartWithStatus(sessionStatus: MeetingSessionStatus) {
        MeetingSession.shared.meetingSession?.logger.info(msg:
            "VideoSession started with status \(sessionStatus.statusCode.description)")
    }
    
    func videoSessionDidStopWithStatus(sessionStatus: MeetingSessionStatus) {
        MeetingSession.shared.meetingSession?.logger.info(msg: "VideoSession stopped with status \(sessionStatus.statusCode.description)")
    }
    
    func remoteVideoSourcesDidBecomeAvailable(sources: [RemoteVideoSource]) {
        for remoteSourceAvailable in sources {
            MeetingSession.shared.meetingSession?.logger.info(msg: "Remote video source became available: \(remoteSourceAvailable.attendeeId)")
        }
    }
    
    func remoteVideoSourcesDidBecomeUnavailable(sources: [RemoteVideoSource]) {
        for remoteSourcesUnavailable in sources {
            MeetingSession.shared.meetingSession?.logger.info(msg: "Remote video source became available: \(remoteSourcesUnavailable.attendeeId)")
        }
    }
    
    func cameraSendAvailabilityDidChange(available: Bool) {
        // Out of scope
    }
}
