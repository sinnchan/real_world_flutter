import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:real_world_flutter/presentation/data_source/articles_data_source.dart';

part 'articles_view_model.freezed.dart';

@freezed
class ArticlesOrganizmViewModel with _$ArticlesOrganizmViewModel {
  const factory ArticlesOrganizmViewModel({
    required bool isLoading,
    required List<ArticlesTab> tabs,
  }) = _ViewModel;
}

@freezed
class ArticlesTab with _$ArticlesTab {
  const factory ArticlesTab({
    required String name,
    required ArticlesDataSource dataSource,
  }) = _Tab;
}

enum ArticlesTabType {
  your,
  global,
  tag,
}
