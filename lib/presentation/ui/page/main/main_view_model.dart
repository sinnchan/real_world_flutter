import 'package:freezed_annotation/freezed_annotation.dart';

part 'main_view_model.freezed.dart';

@freezed
class MainViewModel with _$MainViewModel {
  const factory MainViewModel({
    required int selectedTabIndex,
  }) = _MainViewModel;
}

