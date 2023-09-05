import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:real_world_flutter/domain/repository/user_repository.dart';
import 'package:real_world_flutter/domain/util/logger.dart';
import 'package:real_world_flutter/presentation/navigation/app_navigation.dart';
import 'package:real_world_flutter/presentation/ui/profile/organisms/sign_up_view_model.dart';

typedef _Vm = SignUpViewModel;
typedef _Notifier = SignUpStateNotifier;
typedef _Provider = AutoDisposeStateNotifierProvider<_Notifier, _Vm>;

class SignUpStateNotifier extends StateNotifier<_Vm> {
  final UserRepository _userRepository;
  final GoRouter _goRouter;

  SignUpStateNotifier(
    super.state,
    this._userRepository,
    this._goRouter,
  );

  static final provider = _Provider((ref) {
    return _Notifier(
      const _Vm(),
      ref.watch(UserRepository.provider),
      ref.watch(AppNavigation.provider).router,
    );
  });

  void onUpdateUsername(String? value) {
    state = _updateSignUpEnable(
      state.copyWith(username: value ?? ''),
    );
  }

  void onUpdateEmail(String? value) {
    state = _updateSignUpEnable(
      state.copyWith(email: value ?? ''),
    );
  }

  void onUpdatePassword(String? value) {
    state = _updateSignUpEnable(
      state.copyWith(password: value ?? ''),
    );
  }

  void onTapHaveAccount() {
    _goRouter.go('/login');
  }

  void onTapErrorDialogOk() {
    state = state.copyWith(errorMessage: null);
  }

  Future<void> onTapSignUp() async {
    state = state.copyWith(isLoading: true);

    if (state.email.isEmpty || state.password.isEmpty) {
      state = state.copyWith(
        errorMessage: 'Please Enter Email and Password.',
      );
      return;
    }

    final result = await _userRepository.signUp(
      username: state.username,
      email: state.email,
      password: state.password,
    );

    result.when(
      success: (user) {
        pLogger.d(user.toJson());
        state = state.copyWith(isLoading: false);
        _goRouter.go('/');
      },
      failed: (err) {
        pLogger.e(err.toJson());
        state = state.copyWith(
          isLoading: false,
          errorMessage: err.message,
        );
      },
    );
  }

  _Vm _updateSignUpEnable(_Vm newState) {
    return state.copyWith(
      isEnableSignUpButton: newState.username.isNotEmpty &&
          newState.email.isNotEmpty &&
          newState.password.isNotEmpty,
    );
  }
}
