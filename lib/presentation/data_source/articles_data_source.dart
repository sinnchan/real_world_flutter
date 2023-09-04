import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:real_world_flutter/domain/model/article.dart';
import 'package:real_world_flutter/domain/repository/articles_repository.dart';
import 'package:real_world_flutter/presentation/data_source/articles_data_source_type.dart';

part 'articles_data_source.freezed.dart';

class ArticlesDataSource extends ChangeNotifier {
  final ArticlesDataSourceType type;
  final ArticlesRepository repository;

  static const itemsPerPage = 20;
  final Map<int, ArticleListItemPage> _pages = {};
  final Set<int> _pagesBeingFetched = {};
  int? itemCount;
  bool _isDisposed = false;

  ArticlesDataSource({
    required this.type,
    required this.repository,
  });

  static const maxCacheDistance = 100;

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }

  ArticleListItem getByIndex(int index) {
    var startingIndex = (index ~/ itemsPerPage) * itemsPerPage;

    if (_pages.containsKey(startingIndex)) {
      var item = _pages[startingIndex]!.items[index - startingIndex];
      return item;
    }

    _fetchPage(startingIndex);

    return const ArticleListItem.isLoading();
  }

  Future<void> _fetchPage(int startingIndex) async {
    if (_pagesBeingFetched.contains(startingIndex)) {
      return;
    }

    _pagesBeingFetched.add(startingIndex);
    final result = await repository.getArticles(
      offset: startingIndex,
      limit: itemsPerPage,
    );
    _pagesBeingFetched.remove(startingIndex);

    await result.when(
      success: (data) async {
        final (articles, totalCount) = data;

        if (startingIndex + articles.length >= totalCount) {
          itemCount = startingIndex + articles.length;
        }

        _pages[startingIndex] = ArticleListItemPage(
          items: articles.map((e) => ArticleListItem.data(e)).toList(),
          startingIndex: startingIndex,
        );
        _pruneCache(startingIndex);

        if (!_isDisposed) {
          notifyListeners();
        }
      },
      failed: (err) {
        // noop
      },
    );
  }

  void _pruneCache(int currentStartingIndex) {
    final keysToRemove = <int>{};
    for (final key in _pages.keys) {
      if ((key - currentStartingIndex).abs() > maxCacheDistance) {
        keysToRemove.add(key);
      }
    }
    for (final key in keysToRemove) {
      _pages.remove(key);
    }
  }
}

@freezed
class ArticleListItem with _$ArticleListItem {
  const factory ArticleListItem.isLoading() = _Loading;
  const factory ArticleListItem.data(Article article) = _Data;
}

@freezed
class ArticleListItemPage with _$ArticleListItemPage {
  const factory ArticleListItemPage({
    required List<ArticleListItem> items,
    required int startingIndex,
  }) = _Page;
}
