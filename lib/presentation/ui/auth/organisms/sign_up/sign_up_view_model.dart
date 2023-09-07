import 'package:freezed_annotation/freezed_annotation.dart';

part 'sign_up_view_model.freezed.dart';

@freezed
class SignUpViewModel with _$SignUpViewModel {
  const factory SignUpViewModel({
    @Default('') String username,
    @Default('') String email,
    @Default('') String password,
    @Default(false) bool isEnableSignUpButton,
    @Default(false) bool isLoading,
    String? errorMessage,
  }) = _SignInViewModel;
}
