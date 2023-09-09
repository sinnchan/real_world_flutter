import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:kotlin_scope_function/kotlin_scope_function.dart';
import 'package:real_world_flutter/domain/model/article.dart';
import 'package:real_world_flutter/domain/model/author.dart';
import 'package:real_world_flutter/domain/model/result.dart';
import 'package:real_world_flutter/domain/repository/base/base_repository.dart';
import 'package:real_world_flutter/domain/repository/base/repository_fail_type.dart';
import 'package:real_world_flutter/domain/util/logger.dart';
import 'package:real_world_flutter/infrastructure/api/real_world_api.dart';
import 'package:real_world_flutter/infrastructure/api/schema/articles/api_article.dart';
import 'package:real_world_flutter/infrastructure/api/schema/articles/api_article_author.dart';
import 'package:real_world_flutter/infrastructure/api/schema/articles/api_articles_response.dart';
import 'package:real_world_flutter/infrastructure/api/schema/articles/api_single_article_response.dart';
import 'package:real_world_flutter/infrastructure/transfer/secure_storage.dart';

typedef Articles = (List<Article>, int);

class ArticlesRepository extends BaseRepository {
  ArticlesRepository({
    required super.api,
    required super.secStorage,
  });

  static final provider = Provider.autoDispose((ref) {
    return ArticlesRepository(
      api: ref.watch(RealWorldApi.provider),
      secStorage: ref.watch(SecureStorage.provider),
    );
  });

  Future<RepositoryResult<Articles>> getFeeds({
    int offset = 0,
    int limit = 100,
  }) async {
    sLogger.i('ArticlesRepository.getFeeds');

    final token = await secStorage.read(SecureStorageKey.token);
    if (token == null) {
      return const Result.failed(RepositoryFailType.unauthorized());
    }

    final result = await apiResultWrapper(() {
      return api.getFeed(
        offset: offset,
        limit: limit,
        token: ApiToken(token),
      );
    });

    return result.successMap(
      transform: (data) {
        final articles = _toArticlesFromApiResponse(data);
        return (articles, data.articlesCount);
      },
    );
  }

  Future<RepositoryResult<Articles>> getArticles({
    String? tag,
    String? authorName,
    String? favoritedUserName,
    int offset = 0,
    int limit = 100,
  }) async {
    sLogger.i('ArticlesRepository.getArticles');

    final token = await secStorage.read(SecureStorageKey.token);
    final result = await apiResultWrapper(() {
      return api.getArticles(
        tag: tag,
        authorName: authorName,
        favoritedUserName: favoritedUserName,
        offset: offset,
        limit: limit,
        token: token?.let((it) => ApiToken(it)),
      );
    });

    return result.successMap(
      transform: (data) {
        final articles = _toArticlesFromApiResponse(data);
        return (articles, data.articlesCount);
      },
    );
  }

  Future<RepositoryResult<Article>> getArticle({
    required String slug,
  }) async {
    sLogger.i('ArticlesRepository.getArticle');

    final result = await apiResultWrapper(() {
      return api.getArticle(slug: slug);
    });

    return result.successMap(
      transform: (data) => _toArticleFromApiResponse(data),
    );
  }

  Future<RepositoryResult<Article>> putArticle({
    required String slug,
    String? title,
    String? description,
    String? body,
  }) async {
    sLogger.i('ArticlesRepository.putArticle');

    final token = await secStorage.read(SecureStorageKey.token);
    if (token == null) {
      return const Result.failed(RepositoryFailType.unauthorized());
    }

    final article = <String, String>{};
    if (title != null) {
      article['titile'] = title;
    }
    if (description != null) {
      article['description'] = description;
    }
    if (body != null) {
      article['body'] = body;
    }

    final requestBody = {'article': article};
    final result = await apiResultWrapper(() {
      return api.putArticle(
        slug: slug,
        body: requestBody,
        token: ApiToken(token),
      );
    });

    return result.successMap(
      transform: (data) => _toArticleFromApiResponse(data),
    );
  }

  Future<RepositoryResult<void>> deleteArticle({
    required String slug,
  }) async {
    sLogger.i('ArticlesRepository.deleteArticle');

    final token = await secStorage.read(SecureStorageKey.token);
    if (token == null) {
      return const Result.failed(RepositoryFailType.unauthorized());
    }

    return apiResultWrapper(() {
      return api.deleteArticle(
        slug: slug,
        token: ApiToken(token),
      );
    });
  }

  Article _toArticleFromApiResponse(ApiSingleArticleResponse data) {
    return Article(
      slug: data.article.slug,
      title: data.article.title,
      description: data.article.description,
      body: data.article.body,
      tagList: data.article.tagList,
      createdAt: data.article.createdAt,
      updatedAt: data.article.updatedAt,
      favorited: data.article.favorited,
      favoritesCount: data.article.favoritesCount,
      author: _toAuthorFromApi(data.article.author),
    );
  }

  List<Article> _toArticlesFromApiResponse(ApiArticlesResponse data) {
    return data.articles.map((ApiArticle e) {
      return Article(
        slug: e.slug,
        title: e.title,
        description: e.description,
        body: e.body,
        tagList: e.tagList,
        createdAt: e.createdAt,
        updatedAt: e.updatedAt,
        favorited: e.favorited,
        favoritesCount: e.favoritesCount,
        author: _toAuthorFromApi(e.author),
      );
    }).toList();
  }

  Author _toAuthorFromApi(ApiArticleAuthor e) {
    return Author(
      username: e.username,
      image: e.image,
      following: e.following ?? false,
    );
  }
}
