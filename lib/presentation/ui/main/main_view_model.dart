import 'package:freezed_annotation/freezed_annotation.dart';

part 'main_view_model.freezed.dart';

@freezed
class MainViewModel with _$MainViewModel {
  const factory MainViewModel({
    @Default(0) int selectedTabIndex,
    @Default(false) bool isShowSettingBottomTab,
    @Default(false) bool isShowActionButton,
    @Default(true) bool isShowTagButton,
  }) = _MainViewModel;
}
