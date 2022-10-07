/*
 * Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
 * SPDX-License-Identifier: MIT-0
 */
 
import AmazonChimeSDK
import AmazonChimeSDKMedia
import Foundation

class MyVideoTileObserver: VideoTileObserver {
    weak var methodChannel: MethodChannelCoordinator?
    
    init(withMethodChannel methodChannel: MethodChannelCoordinator) {
        self.methodChannel = methodChannel
    }
    
    func videoTileDidAdd(tileState: VideoTileState) {
        methodChannel?.callFlutterMethod(method: .videoTileAdd, args: videoTileStateToDict(state: tileState))
    }
    
    func videoTileDidRemove(tileState: VideoTileState) {
        MeetingSession.shared.meetingSession?.audioVideo.unbindVideoView(tileId: tileState.tileId)
        methodChannel?.callFlutterMethod(method: .videoTileRemove, args: videoTileStateToDict(state: tileState))
    }
    
    func videoTileDidPause(tileState: VideoTileState) {
        // Out of Scope
    }
    
    func videoTileDidResume(tileState: VideoTileState) {
        // Out of Scope
    }
    
    func videoTileSizeDidChange(tileState: VideoTileState) {
        // Out of Scope
    }
    
    private func videoTileStateToDict(state: VideoTileState) -> [String: Any?] {
        return [
            "tileId": state.tileId,
            "attendeeId": state.attendeeId,
            "videoStreamContentWidth": state.videoStreamContentWidth,
            "videoStreamContentHeight": state.videoStreamContentHeight,
            "isLocalTile": state.isLocalTile,
            "isContent": state.isContent
        ]
    }
}
