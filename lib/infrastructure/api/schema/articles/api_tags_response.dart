import 'package:freezed_annotation/freezed_annotation.dart';

part 'api_tags_response.freezed.dart';
part 'api_tags_response.g.dart';

@freezed
class ApiTagResponse with _$ApiTagResponse {
  const factory ApiTagResponse({
    required List<String> tags,
  }) = _ApiTagResponse;

  factory ApiTagResponse.fromJson(Map<String, dynamic> json) =>
      _$ApiTagResponseFromJson(json);
}
