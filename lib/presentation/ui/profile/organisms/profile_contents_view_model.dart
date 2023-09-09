import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:real_world_flutter/domain/model/profile.dart';
import 'package:real_world_flutter/presentation/data_source/articles_data_source.dart';

part 'profile_contents_view_model.freezed.dart';

@freezed
class ProfileContentsViewModel with _$ProfileContentsViewModel {
  const factory ProfileContentsViewModel({
    Profile? profile,
    ArticlesDataSource? myArticlesDataSource,
    ArticlesDataSource? favoritesArticlesDataSource,
    String? errorMessage,
    @Default(false) bool isLoading,
  }) = _ProfileContentsViewModelIdle;
}
