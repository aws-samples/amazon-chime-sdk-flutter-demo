/*
 * Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
 * SPDX-License-Identifier: MIT-0
 */
 
import AmazonChimeSDK
import Foundation

class VideoTileView: NSObject, FlutterPlatformView {
    private var _view: UIView

    init(
        frame: CGRect,
        viewIdentifier viewId: Int64,
        arguments args: Any?
    ) {
        _view = DefaultVideoRenderView()
        super.init()
           
        // Receieve tileId as a param.
        let tileId = args as! Int
        let videoRenderView = _view as! VideoRenderView
           
        // Bind view to VideoView
        MeetingSession.shared.meetingSession?.audioVideo.bindVideoView(videoView: videoRenderView, tileId: tileId)
           
        // Fix aspect ratio
        _view.contentMode = .scaleAspectFit
           
        // Declare _view as UIView for Flutter interpretation
        _view = _view as UIView
    }

    func view() -> UIView {
        return _view
    }
}
