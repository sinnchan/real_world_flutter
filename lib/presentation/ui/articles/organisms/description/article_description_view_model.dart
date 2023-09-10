import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:real_world_flutter/domain/model/article.dart';

part 'article_description_view_model.freezed.dart';

@freezed
class ArticleDescriptionViewModel with _$ArticleDescriptionViewModel {
  const factory ArticleDescriptionViewModel({
    Article? article,
    @Default(false) bool isLoading,
    String? errorMessage,
  }) = _ArticleDescriptionViewModel;
}
