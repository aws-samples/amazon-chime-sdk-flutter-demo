class AmazonChannelResponse {
  final bool result;
  final dynamic arguments;

  const AmazonChannelResponse(this.result, [this.arguments]);

  factory AmazonChannelResponse.fromJson(dynamic json) {
    return AmazonChannelResponse(json["result"], json["arguments"]);
  }

  @override
  bool operator ==(covariant AmazonChannelResponse other) {
    if (identical(this, other)) return true;

    return other.result == result && other.arguments == arguments;
  }

  @override
  int get hashCode => result.hashCode ^ arguments.hashCode;

  @override
  String toString() {
    return 'AmazonChannelResponse(result: $result, arguments: $arguments)';
  }
}
