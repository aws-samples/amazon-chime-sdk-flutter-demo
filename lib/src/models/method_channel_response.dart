// ignore_for_file: public_member_api_docs, sort_constructors_first
class MethodChannelResponse {
  late bool result;
  dynamic arguments;

  MethodChannelResponse(this.result, this.arguments);

  factory MethodChannelResponse.fromJson(dynamic json) {
    return MethodChannelResponse(json["result"], json["arguments"]);
  }

  @override
  String toString() =>
      'MethodChannelResponse(result: $result, arguments: $arguments)';
}
