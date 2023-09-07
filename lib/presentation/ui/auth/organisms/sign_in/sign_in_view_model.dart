import 'package:freezed_annotation/freezed_annotation.dart';

part 'sign_in_view_model.freezed.dart';

@freezed
class SignInViewModel with _$SignInViewModel {
  const factory SignInViewModel({
    @Default('') String email,
    @Default('') String password,
    @Default(false) bool isEnableSignInButton,
    @Default(false) bool isLoading,
    String? errorMessage,
  }) = _SignInViewModel;
}
