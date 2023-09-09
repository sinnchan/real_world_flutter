import 'package:freezed_annotation/freezed_annotation.dart';

part 'articles_data_source_type.freezed.dart';

@freezed
class ArticlesDataSourceType with _$ArticlesDataSourceType {
  const factory ArticlesDataSourceType.global() = _Global;
  const factory ArticlesDataSourceType.yourFeed() = _YourFeed;
  const factory ArticlesDataSourceType.myArticles({
    required String authorName,
  }) = _MyArticles;
  const factory ArticlesDataSourceType.favorites({
    required String username,
  }) = _Favorites;
  const factory ArticlesDataSourceType.tag({
    required String tag,
  }) = _Tag;
}
