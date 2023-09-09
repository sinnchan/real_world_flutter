import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:real_world_flutter/domain/model/article.dart';
import 'package:real_world_flutter/domain/repository/articles_repository.dart';
import 'package:real_world_flutter/domain/util/logger.dart';
import 'package:real_world_flutter/presentation/navigation/app_navigation.dart';
import 'package:real_world_flutter/presentation/ui/articles/molecules/lsit_item/article_list_item_view_model.dart';

typedef _Vm = ArticleListItemViewModel;
typedef _Notifier = ArticleListItemNotifier;
typedef _Provider
    = AutoDisposeStateNotifierProviderFamily<_Notifier, _Vm, Article>;

class ArticleListItemNotifier extends StateNotifier<_Vm> {
  final ArticlesRepository _articlesRepository;
  final GoRouter _goRouter;
  var _isDisposed = false;

  ArticleListItemNotifier(
    super.state,
    this._articlesRepository,
    this._goRouter,
  );

  static final provider = _Provider((ref, article) {
    return _Notifier(
      _Vm(artile: article),
      ref.watch(ArticlesRepository.provider),
      ref.watch(AppNavigation.provider).router,
    );
  });

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }

  void onTapAuthorInfo() {
    _goRouter.push('/article/${state.artile.slug}');
  }

  Future<void> onTapFavoriteButton() async {
    state = state.copyWith(isLockedFavoriteButton: true);

    final result = await _articlesRepository.favorite(
      slug: state.artile.slug,
      favorite: !state.artile.favorited,
    );

    if (_isDisposed) {
      return;
    }
    state = result.when(
      success: (article) {
        return _Vm(
          artile: article,
          isLockedFavoriteButton: false,
        );
      },
      failed: (err) {
        pLogger.w('failed to update favorite state.');
        return state.copyWith(isLockedFavoriteButton: false);
      },
    );
  }

  void onTapContents() {}
}
