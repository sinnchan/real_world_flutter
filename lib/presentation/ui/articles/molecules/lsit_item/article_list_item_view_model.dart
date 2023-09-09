import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:real_world_flutter/domain/model/article.dart';

part 'article_list_item_view_model.freezed.dart';

@freezed
class ArticleListItemViewModel with _$ArticleListItemViewModel {
  const factory ArticleListItemViewModel({
    required Article artile,
    @Default(false) isLockedFavoriteButton,
  }) = _ArticleListItemViewModel;
}
