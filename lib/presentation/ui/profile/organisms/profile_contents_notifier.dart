import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:real_world_flutter/domain/model/result.dart';
import 'package:real_world_flutter/domain/repository/articles_repository.dart';
import 'package:real_world_flutter/domain/repository/profile_repository.dart';
import 'package:real_world_flutter/domain/repository/user_repository.dart';
import 'package:real_world_flutter/domain/util/logger.dart';
import 'package:real_world_flutter/presentation/data_source/articles_data_source.dart';
import 'package:real_world_flutter/presentation/data_source/articles_data_source_type.dart';
import 'package:real_world_flutter/presentation/ui/profile/organisms/profile_contents_view_model.dart';

typedef _Vm = ProfileContentsViewModel;
typedef _Notifier = ProfileNotifier;
typedef _Provider
    = AutoDisposeStateNotifierProviderFamily<_Notifier, _Vm, String?>;

class ProfileNotifier extends StateNotifier<_Vm> {
  final ProfileRepository _profileRepository;
  final UserRepository _userRepository;
  final ArticlesRepository _articlesRepository;
  var _isDisposed = false;

  ProfileNotifier(
    super.state,
    this._profileRepository,
    this._userRepository,
    this._articlesRepository,
  );

  static final provider = _Provider((ref, username) {
    sLogger.d('Instantinate profile notifier');
    final notifier = ProfileNotifier(
      const _Vm(),
      ref.watch(ProfileRepository.provider),
      ref.watch(UserRepository.provider),
      ref.watch(ArticlesRepository.provider),
    )..loadState(username);

    return notifier;
  });

  @override
  void dispose() {
    _isDisposed = true;
    sLogger.d('Dispose profile notifier');
    super.dispose();
  }

  Future<void> loadState(String? username) async {
    state = state.copyWith(isLoading: true);

    String name;
    if (username != null) {
      name = username;
    } else {
      final user = await _userRepository.getUser();
      switch (user) {
        case Success(data: final data):
          name = data.username;
        case Failed(error: final err):
          state = state.copyWith(
            errorMessage: 'no user data \n${err.message}',
          );
          return;
        default:
          return;
      }
    }

    final result = await _profileRepository.getProfile(username: name);

    if (_isDisposed) {
      return;
    }

    result.when(
      success: (profile) {
        state = _Vm(
          profile: profile,
          myArticlesDataSource: ArticlesDataSource(
            type: ArticlesDataSourceType.myArticles(authorName: name),
            repository: _articlesRepository,
          ),
          favoritesArticlesDataSource: ArticlesDataSource(
            type: ArticlesDataSourceType.favorites(username: name),
            repository: _articlesRepository,
          ),
          errorMessage: null,
          isLoading: false,
        );
      },
      failed: (err) {
        state = state.copyWith(
          errorMessage: 'failed to get profile data.\n${err.message}',
        );
      },
    );
  }

  void onTapErrorDialogOk() {
    state = state.copyWith(errorMessage: null);
  }
}
