import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:real_world_flutter/domain/repository/user_repository.dart';
import 'package:real_world_flutter/domain/util/logger.dart';
import 'package:real_world_flutter/presentation/navigation/app_navigation.dart';
import 'package:real_world_flutter/presentation/ui/profile/organisms/sign_in_view_model.dart';

typedef _Vm = SignInViewModel;
typedef _Notifier = SignInStateNotifier;
typedef _Provider = AutoDisposeStateNotifierProvider<_Notifier, _Vm>;

class SignInStateNotifier extends StateNotifier<SignInViewModel> {
  final UserRepository _userRepository;
  final GoRouter _goRouter;

  SignInStateNotifier(
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

  void onUpdateEmail(String? value) {
    final email = value ?? '';
    state = state.copyWith(
      email: email,
      isEnableSignInButton: email.isNotEmpty && state.password.isNotEmpty,
    );
  }

  void onUpdatePassword(String? value) {
    final password = value ?? '';
    state = state.copyWith(
      password: password,
      isEnableSignInButton: state.email.isNotEmpty && password.isNotEmpty,
    );
  }
  void onTapNeedAccount() {
    _goRouter.go('/register');
  }

  void onTapErrorDialogOk() {
    state = state.copyWith(errorMessage: null);
  }

  Future<void> onTapSignIn() async {
    state = state.copyWith(isLoading: true);

    if (state.email.isEmpty || state.password.isEmpty) {
      state = state.copyWith(
        errorMessage: 'Please Enter Email and Password.',
      );
      return;
    }

    final result = await _userRepository.signIn(
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

}
