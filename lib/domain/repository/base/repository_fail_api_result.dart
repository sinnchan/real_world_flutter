import 'package:freezed_annotation/freezed_annotation.dart';

part 'repository_fail_api_result.freezed.dart';

// repository <-> api
@freezed
class ApiFailResult with _$ApiFailResult {
  const factory ApiFailResult({
    required int? statusCode,
    required String? statusMessage,
  }) = _ApiFailResultResponse;
}
