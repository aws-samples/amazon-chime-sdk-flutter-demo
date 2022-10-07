/*
 * Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
 * SPDX-License-Identifier: MIT-0
 */
 
import AmazonChimeSDK
import AmazonChimeSDKMedia
import AVFoundation
import Flutter
import Foundation

// Singleton Pattern Class
class MeetingSession {
    static let shared = MeetingSession()
    
    var meetingSession: DefaultMeetingSession?
    
    let audioVideoConfig = AudioVideoConfiguration()
    private let logger = ConsoleLogger(name: "MeetingSession")
    
    private init() {}
    
    func startMeetingAudio() -> MethodChannelResponse {
        let audioSessionConfigured = configureAudioSession()
        let audioSessionStarted = startAudioVideoConnection()
        if audioSessionStarted, audioSessionConfigured {
            return MethodChannelResponse(result: true, arguments: Response.create_meeting_success.rawValue)
        }
        return MethodChannelResponse(result: false, arguments: Response.meeting_start_failed.rawValue)
    }
    
    private func startAudioVideoConnection() -> Bool {
        do {
            try meetingSession?.audioVideo.start()
            meetingSession?.audioVideo.startRemoteVideo()
        } catch PermissionError.audioPermissionError {
            logger.error(msg: "Audio permissions error.")
            return false
        } catch {
            logger.error(msg: "Error starting the Meeting: \(error.localizedDescription)")
            return false
        }
        return true
    }
    
    private func configureAudioSession() -> Bool {
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
            try audioSession.setMode(.voiceChat)
        } catch {
            logger.error(msg: "Error configuring AVAudioSession: \(error.localizedDescription)")
            return false
        }
        return true
    }
}
