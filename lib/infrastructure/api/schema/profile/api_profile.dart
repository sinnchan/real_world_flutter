import 'package:freezed_annotation/freezed_annotation.dart';

part 'api_profile.freezed.dart';
part 'api_profile.g.dart';

@freezed
class ApiProfileResponse with _$ApiProfileResponse {
  const factory ApiProfileResponse({
    required ApiProfile profile,
  }) = _ApiProfileResponse;

  factory ApiProfileResponse.fromJson(Map<String, dynamic> json) =>
      _$ApiProfileResponseFromJson(json);
}

@freezed
class ApiProfile with _$ApiProfile {
  const factory ApiProfile({
    required String username,
    String? bio,
    Uri? image,
    required bool following,
  }) = _ApiProfile;

  factory ApiProfile.fromJson(Map<String, dynamic> json) =>
      _$ApiProfileFromJson(json);
}
