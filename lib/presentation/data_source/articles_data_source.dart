import 'package:collection/collection.dart';
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
  String? errorMessage;

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

  ArticleListItemType getByIndex(int index) {
    var startingIndex = (index ~/ itemsPerPage) * itemsPerPage;

    if (_pages.containsKey(startingIndex)) {
      var item = _pages[startingIndex]!.items[index - startingIndex];
      return item;
    }

    _fetchPage(startingIndex);

    return const ArticleListItemType.isLoading();
  }

  void reload() {
    if (_isDisposed) {
      return;
    }
    itemCount = null;
    _pages.clear();
    errorMessage = null;
    notifyListeners();
  }

  void updateArticle(Article newArticle) {
    for (final entry in _pages.entries) {
      final match = entry.value.items.firstWhereOrNull((item) {
        return item.whenOrNull(data: (d) => d)?.slug == newArticle.slug;
      });

      if (match != null) {
        final mutableItems = entry.value.items.toList();
        final index = mutableItems.indexOf(match);
        final newItem = ArticleListItemType.data(newArticle);

        _pages[entry.key] = entry.value.copyWith(
          items: mutableItems
            ..removeAt(index)
            ..insert(index, newItem),
        );

        if (!_isDisposed) {
          Future(() {
            notifyListeners();
          });
        }
        break;
      }
    }
  }

  Future<void> _fetchPage(int startingIndex) async {
    if (_pagesBeingFetched.contains(startingIndex)) {
      return;
    }

    _pagesBeingFetched.add(startingIndex);
    final result = await type.when(
      yourFeed: () => repository.getFeeds(
        offset: startingIndex,
        limit: itemsPerPage,
      ),
      global: () => repository.getArticles(
        offset: startingIndex,
        limit: itemsPerPage,
      ),
      myArticles: (authorName) => repository.getArticles(
        authorName: authorName,
        offset: startingIndex,
        limit: itemsPerPage,
      ),
      favorites: (username) => repository.getArticles(
        favoritedUserName: username,
        offset: startingIndex,
        limit: itemsPerPage,
      ),
      tag: (tag) => repository.getArticles(
        tag: tag,
        offset: startingIndex,
        limit: itemsPerPage,
      ),
    );
    _pagesBeingFetched.remove(startingIndex);

    await result.when(
      success: (data) async {
        final (articles, totalCount) = data;

        if (startingIndex + articles.length >= totalCount) {
          itemCount = startingIndex + articles.length;
        }

        _pages[startingIndex] = ArticleListItemPage(
          items: articles.map((e) => ArticleListItemType.data(e)).toList(),
          startingIndex: startingIndex,
        );
        _pruneCache(startingIndex);
      },
      failed: (err) {
        errorMessage = 'Fetch error...\n${err.message}';
      },
    );

    if (!_isDisposed) {
      notifyListeners();
    }
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
class ArticleListItemType with _$ArticleListItemType {
  const factory ArticleListItemType.isLoading() = _Loading;
  const factory ArticleListItemType.data(Article article) = _Data;
}

@freezed
class ArticleListItemPage with _$ArticleListItemPage {
  const factory ArticleListItemPage({
    required List<ArticleListItemType> items,
    required int startingIndex,
  }) = _Page;
}
