import 'package:freezed_annotation/freezed_annotation.dart';

part 'article_edit_view_model.freezed.dart';

@freezed
class ArticleEditViewModel with _$ArticleEditViewModel {
  const factory ArticleEditViewModel({
    @Default('') String title,
    @Default('') String description,
    @Default('') String body,
    @Default([]) List<String> tags,
    @Default(false) bool isLoading,
    @Default(false) bool isEnableButton,
    String? errorMessage,
  }) = _ArticleEditViewModel;
}
