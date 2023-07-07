class MediaPlacementModel {
  final String audioHostUrl;
  final String audioFallbackUrl;
  final String signalingUrl;
  final String turnControllerUrl;

  MediaPlacementModel(this.audioHostUrl, this.audioFallbackUrl,
      this.signalingUrl, this.turnControllerUrl);

  factory MediaPlacementModel.fromJson(Map<String, dynamic> json) {
    var mediaPlacementMap =
        json['JoinInfo']['Meeting']['Meeting']['MediaPlacement'];
    return MediaPlacementModel(
      mediaPlacementMap['AudioHostUrl'],
      mediaPlacementMap['AudioFallbackUrl'],
      mediaPlacementMap['SignalingUrl'],
      mediaPlacementMap['TurnControlUrl'],
    );
  }
}
