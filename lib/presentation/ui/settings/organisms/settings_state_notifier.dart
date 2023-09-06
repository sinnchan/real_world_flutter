import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:real_world_flutter/domain/repository/user_repository.dart';
import 'package:real_world_flutter/domain/util/logger.dart';
import 'package:real_world_flutter/presentation/navigation/app_navigation.dart';
import 'package:real_world_flutter/presentation/ui/settings/organisms/settings_view_model.dart';

typedef _Vm = SettingsViewModel;
typedef _Notifier = SettingsStateNotifier;
typedef _Provider = AutoDisposeStateNotifierProvider<_Notifier, _Vm>;

class SettingsStateNotifier extends StateNotifier<SettingsViewModel> {
  final UserRepository _userRepository;
  final GoRouter _router;
  var _isInitialized = false;
  var _isDisposed = false;

  SettingsStateNotifier(
    super.state,
    this._userRepository,
    this._router,
  );

  static final provider = _Provider((ref) {
    sLogger.d('Instantinate settings notifier');
    return SettingsStateNotifier(
      const SettingsViewModel(),
      ref.watch(UserRepository.provider),
      ref.watch(AppNavigation.provider).router,
    )..loadState();
  });

  @override
  void dispose() {
    sLogger.d('Disposed settings notifier');
    _isDisposed = true;
    super.dispose();
  }

  Future<void> loadState() async {
    state = state.copyWith(isLoading: true);

    final result = await _userRepository.getUser();

    if (_isDisposed) {
      return;
    }
    result.when(
      success: (user) {
        pLogger.d(user);
        state = _Vm(
          isLoading: false,
          imageUrl: user.image?.toString(),
          username: user.username,
          bio: user.bio,
          email: user.email,
          password: '',
        );
        _isInitialized = true;
      },
      failed: (err) {
        pLogger.w(err);
        state = state.copyWith(
          isLoading: false,
          errorMessage: 'Failed to get user data.',
        );
      },
    );
  }

  void updatePictureUrl(String? value) {
    state = state.copyWith(imageUrl: value);
  }

  void updateUsername(String? value) {
    state = state.copyWith(username: value);
  }

  void updateBio(String? value) {
    state = state.copyWith(bio: value);
  }

  void updateEmail(String? value) {
    state = state.copyWith(email: value);
  }

  void updatePassword(String? value) {
    state = state.copyWith(password: value);
  }

  void onTapErrorDialogOk() {
    state = state.copyWith(errorMessage: null);
    if (!_isInitialized) {
      _router.go('/');
    }
  }

  Future<void> onTapUpdateButton() async {
    state = state.copyWith(isLoading: true);
    final result = await _userRepository.updateUser(
      pictureUrl: state.imageUrl,
      username: state.username,
      bio: state.bio,
      email: state.email,
      password: state.password,
    );

    if (_isDisposed) {
      return;
    }
    result.when(
      success: (user) {
        pLogger.d(user.toJson());
        state = _Vm(
          isLoading: false,
          imageUrl: user.image?.toString(),
          username: user.username,
          bio: user.bio,
          email: user.email,
          password: '',
        );
      },
      failed: (err) {
        pLogger.w(err.toJson());
        state = state.copyWith(
          isLoading: false,
          errorMessage: 'Failed to update settings.\nPlease try again.',
        );
      },
    );
  }

  Future<void> onTapSignoutButton() async {
    return _userRepository.signOut();
  }
}
