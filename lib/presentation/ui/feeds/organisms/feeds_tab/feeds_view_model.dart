import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:real_world_flutter/presentation/data_source/articles_data_source.dart';

part 'feeds_view_model.freezed.dart';

@freezed
class FeedsViewModel with _$FeedsViewModel {
  const factory FeedsViewModel({
    required bool isLoading,
    required List<FeedsTab> tabs,
  }) = _ViewModel;
}

@freezed
class FeedsTab with _$FeedsTab {
  const factory FeedsTab({
    required String name,
    required ArticlesDataSource dataSource,
  }) = _Tab;
}

