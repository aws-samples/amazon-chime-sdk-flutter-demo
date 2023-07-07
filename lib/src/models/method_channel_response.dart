class MethodChannelResponse {
  late bool result;
  dynamic arguments;

  MethodChannelResponse(this.result, this.arguments);

  factory MethodChannelResponse.fromJson(dynamic json) {
    return MethodChannelResponse(json["result"], json["arguments"]);
  }
}
