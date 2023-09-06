import 'package:freezed_annotation/freezed_annotation.dart';

part 'settings_view_model.freezed.dart';

@freezed
class SettingsViewModel with _$SettingsViewModel {
  const factory SettingsViewModel({
    @Default(false) bool isLoading,
    String? errorMessage,
    String? imageUrl,
    String? username,
    String? bio,
    String? email,
    String? password,
  }) = _SettingsViewModel;
}
