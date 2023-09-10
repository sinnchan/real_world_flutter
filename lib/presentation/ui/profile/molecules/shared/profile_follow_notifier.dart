import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:real_world_flutter/domain/repository/profile_repository.dart';
import 'package:real_world_flutter/presentation/ui/profile/molecules/shared/profile_follow_view_model.dart';

typedef _Vm = ProfileFollowViewModel;
typedef _Notifier = ProfileFollowNotifier;
typedef _Provider
    = AutoDisposeStateNotifierProviderFamily<_Notifier, _Vm, String>;

class ProfileFollowNotifier extends StateNotifier<_Vm> {
  final ProfileRepository _profileRepository;
  var _isDisposed = false;

  ProfileFollowNotifier(
    super.state,
    this._profileRepository,
  );

  static final provider = _Provider((ref, username) {
    return _Notifier(
      _Vm(username: username),
      ref.watch(ProfileRepository.provider),
    );
  });

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }

  Future<void> loadState() async {
    state = state.copyWith(lockFollowButton: true);

    final result = await _profileRepository.getProfile(
      username: state.username,
    );

    if (_isDisposed) {
      return;
    }
    result.when(
      success: (profile) {
        state = state.copyWith(
          follwoing: profile.following,
          lockFollowButton: false,
        );
      },
      failed: (err) {
        state = state.copyWith(
          lockFollowButton: false,
          errorMessage: 'failed to get profile... ${err.message}',
        );
      },
    );
  }

  Future<void> onTapFollow() async {
    state = state.copyWith(lockFollowButton: true);

    final task = state.follwoing
        ? _profileRepository.unfollow(username: state.username)
        : _profileRepository.follow(username: state.username);
    final result = await task;

    if (_isDisposed) {
      return;
    }
    result.when(
      success: (profile) {
        state = state.copyWith(
          follwoing: profile.following,
          lockFollowButton: false,
        );
      },
      failed: (err) {
        state = state.copyWith(
          lockFollowButton: false,
          errorMessage: 'failed to get profile... ${err.message}',
        );
      },
    );
  }

  void onTapErorDialogOk() {
    state = state.copyWith(errorMessage: null);
  }
}
