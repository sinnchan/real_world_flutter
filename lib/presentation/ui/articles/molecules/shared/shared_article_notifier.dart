import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:kotlin_scope_function/kotlin_scope_function.dart';
import 'package:real_world_flutter/domain/model/article.dart';
import 'package:real_world_flutter/domain/repository/articles_repository.dart';
import 'package:real_world_flutter/domain/util/logger.dart';
import 'package:real_world_flutter/presentation/navigation/app_navigation.dart';
import 'package:real_world_flutter/presentation/ui/articles/molecules/shared/shared_article_view_model.dart';

typedef _Vm = SharedArticleViewModel;
typedef _Notifier = SharedArticleNotifier;
typedef _Provider
    = AutoDisposeStateNotifierProviderFamily<_Notifier, _Vm, String>;

class SharedArticleNotifier extends StateNotifier<_Vm> {
  final String _slug;
  final ArticlesRepository _articlesRepository;
  final GoRouter _goRouter;
  void Function(Article)? updateArticleLitener;
  var _isDisposed = false;

  SharedArticleNotifier(
    super.state,
    this._slug,
    this._articlesRepository,
    this._goRouter,
  );

  static final provider = _Provider((ref, slug) {
    return _Notifier(
      const _Vm(),
      slug,
      ref.watch(ArticlesRepository.provider),
      ref.watch(AppNavigation.provider).router,
    );
  });

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }

  void updateArticle(Article newArticle) {
    final updated = newArticle.updatedAt.millisecondsSinceEpoch >
        (state.artile?.updatedAt.millisecondsSinceEpoch ?? 0);

    Future(() {
      if (newArticle.slug == _slug && updated && !_isDisposed) {
        state = state.copyWith(artile: newArticle);
      }
    });
  }

  void onTapAuthorInfo() {
    state.artile?.let((it) {
      _goRouter.push('/profile/${it.author.username}');
    });
  }

  Future<void> onTapFavoriteButton() async {
    state = state.copyWith(isLockedFavoriteButton: true);

    final article = state.artile;
    if (article == null) {
      return;
    }

    final result = await _articlesRepository.favorite(
      slug: article.slug,
      favorite: !article.favorited,
    );

    final newState = result.when(
      success: (article) {
        updateArticleLitener?.call(article);
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

    Future(() {
      if (!_isDisposed) {
        state = newState;
      }
    });
  }

  void onTapContents() {
    final article = state.artile;
    if (article != null) {
      _goRouter.push('/article/${article.slug}');
    } else {
      _goRouter.go('/');
    }
  }
}
