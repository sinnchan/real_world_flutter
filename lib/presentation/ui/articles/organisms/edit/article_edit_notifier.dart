import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:real_world_flutter/domain/repository/articles_repository.dart';
import 'package:real_world_flutter/presentation/navigation/app_navigation.dart';
import 'package:real_world_flutter/presentation/ui/articles/organisms/edit/article_edit_view_model.dart';

typedef _Vm = ArticleEditViewModel;
typedef _Notifier = ArticleEditNotifier;
typedef _Provider = AutoDisposeStateNotifierProvider<_Notifier, _Vm>;

class ArticleEditNotifier extends StateNotifier<_Vm> {
  final ArticlesRepository _articlesRepository;
  final GoRouter _goRouter;
  var _isDisposed = false;

  ArticleEditNotifier(
    super.state,
    this._articlesRepository,
    this._goRouter,
  );

  static final provider = _Provider((ref) {
    return _Notifier(
      const _Vm(),
      ref.watch(ArticlesRepository.provider),
      ref.watch(AppNavigation.provider).router,
    );
  });

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }

  void updateTitle(String title) {
    state = state.copyWith(title: title);
    _updateEnableState();
  }

  void updateDescription(String description) {
    state = state.copyWith(description: description);
    _updateEnableState();
  }

  void updateBody(String body) {
    state = state.copyWith(body: body);
    _updateEnableState();
  }

  void updateTags(String tags) {
    state = state.copyWith(
      tags: tags.split(' ').expand((e) => e.split(',')).toList(),
    );
  }

  Future<void> publish() async {
    state = state.copyWith(isLoading: true);

    final result = await _articlesRepository.postArticle(
      title: state.title,
      description: state.description,
      body: state.body,
      tags: state.tags,
    );

    if (_isDisposed) {
      return;
    }

    result.when(
      success: (_) => _goRouter.go('/'),
      failed: (err) {
        state = state.copyWith(
          isLoading: false,
          errorMessage: 'failed to publish article... ${err.message}',
        );
      },
    );
  }

  void _updateEnableState() {
    state = state.copyWith(
      isEnableButton: state.title.isNotEmpty &&
          state.description.isNotEmpty &&
          state.body.isNotEmpty,
    );
  }

  void onTapErrorDialogOk() {
    state = state.copyWith(errorMessage: null);
  }
}
