import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:real_world_flutter/domain/repository/articles_repository.dart';
import 'package:real_world_flutter/presentation/ui/articles/organisms/description/article_description_view_model.dart';

typedef _Vm = ArticleDescriptionViewModel;
typedef _Notifier = ArticleDescriptionNotifier;
typedef _Provider
    = AutoDisposeStateNotifierProviderFamily<_Notifier, _Vm, String>;

class ArticleDescriptionNotifier extends StateNotifier<_Vm> {
  final ArticlesRepository _articlesRepository;
  var _isDisposed = false;

  ArticleDescriptionNotifier(
    super.state,
    this._articlesRepository,
  );

  static final provider = _Provider((ref, slug) {
    final notifier = _Notifier(
      const _Vm(),
      ref.watch(ArticlesRepository.provider),
    );

    notifier.loadState(slug);

    return notifier;
  });

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }

  Future<void> loadState(String slug) async {
    final result = await _articlesRepository.getArticle(slug: slug);

    if (_isDisposed) {
      return;
    }

    result.when(
      success: (data) {
        state = _Vm(article: data);
      },
      failed: (err) {
        state = state.copyWith(
          errorMessage: 'failed to get article... ${err.message}',
        );
      },
    );
  }

  void onTapFollowButton() {

  }

  void onTapErorDialogOk() {
    state = state.copyWith(errorMessage: null);
  }
}
