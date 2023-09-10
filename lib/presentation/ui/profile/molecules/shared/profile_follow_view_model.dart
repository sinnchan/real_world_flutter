import 'package:freezed_annotation/freezed_annotation.dart';

part 'profile_follow_view_model.freezed.dart';

@freezed
class ProfileFollowViewModel with _$ProfileFollowViewModel {
  const factory ProfileFollowViewModel({
    required String username,
    @Default(false) bool follwoing,
    @Default(false) bool lockFollowButton,
    String? errorMessage,
  }) = _ProfileFollowViewModel;
}
