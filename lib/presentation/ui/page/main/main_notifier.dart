import 'dart:async';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:real_world_flutter/presentation/ui/page/main/main_view_model.dart';

typedef _Vm = MainViewModel;
typedef _Notifier = MainPageNotifier;
typedef _Provider = StateNotifierProvider<_Notifier, _Vm>;

final mainPageNotifier = _Provider((ref) {
  return MainPageNotifier(
    const _Vm(selectedTabIndex: 0),
  );
});

class MainPageNotifier extends StateNotifier<MainViewModel> {
  MainPageNotifier(super.state);

  void onSelectNavigationItem(int index) {
    state = state.copyWith(selectedTabIndex: index);
  }
}
