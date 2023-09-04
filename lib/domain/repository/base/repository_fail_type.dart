import 'package:freezed_annotation/freezed_annotation.dart';

part 'repository_fail_type.freezed.dart';
part 'repository_fail_type.g.dart';

@freezed
class RepositoryFailType with _$RepositoryFailType {
  const factory RepositoryFailType.unauthorized() = _Unauthorized;
  const factory RepositoryFailType.unexpected({
    required String message,
  }) = _Unexpected;

  factory RepositoryFailType.fromJson(Map<String, dynamic> json) =>
      _$RepositoryFailTypeFromJson(json);
}
