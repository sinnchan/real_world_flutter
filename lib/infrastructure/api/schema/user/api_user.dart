import 'package:freezed_annotation/freezed_annotation.dart';

part 'api_user.freezed.dart';
part 'api_user.g.dart';

@freezed
class ApiUser with _$ApiUser {
  const factory ApiUser({
    required String email,
    required String username,
    String? bio,
    required Uri image,
    required String token,
  }) = _ApiUser;

  factory ApiUser.fromJson(Map<String, dynamic> json) =>
      _$ApiUserFromJson(json);
}

@freezed
class ApiUserResponse with _$ApiUserResponse {
  const factory ApiUserResponse({
    required ApiUser user,
  }) = _ApiUserResponseSuccess;

  factory ApiUserResponse.fromJson(Map<String, dynamic> json) =>
      _$ApiUserResponseFromJson(json);
}

