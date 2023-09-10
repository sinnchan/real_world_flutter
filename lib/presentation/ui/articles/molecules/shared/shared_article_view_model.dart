import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:real_world_flutter/domain/model/article.dart';

part 'shared_article_view_model.freezed.dart';

@freezed
class SharedArticleViewModel with _$SharedArticleViewModel {
  const factory SharedArticleViewModel({
    Article? artile,
    @Default(false) isLockedFavoriteButton,
  }) = _SharedArticleViewModel;
}
