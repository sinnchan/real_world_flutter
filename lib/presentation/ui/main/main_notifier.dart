import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:real_world_flutter/domain/repository/user_repository.dart';
import 'package:real_world_flutter/presentation/navigation/app_navigation.dart';
import 'package:real_world_flutter/presentation/ui/main/main_view_model.dart';
import 'package:rxdart/utils.dart';

typedef _Vm = MainViewModel;
typedef _Notifier = MainPageNotifier;
typedef _Provider = AutoDisposeStateNotifierProvider<_Notifier, _Vm>;

class MainPageNotifier extends StateNotifier<MainViewModel> {
  final GoRouter goRouter;
  final UserRepository userRepository;
  final subscriptions = CompositeSubscription();

  MainPageNotifier(
    super.state, {
    required this.goRouter,
    required this.userRepository,
  });

  static final provider = _Provider((ref) {
    return MainPageNotifier(
      const _Vm(
        selectedTabIndex: 0,
        isLoggedIn: false,
      ),
      goRouter: ref.watch(AppNavigation.provider).router,
      userRepository: ref.watch(UserRepository.provider),
    )..loadState();
  });

  @override
  void dispose() {
    subscriptions.dispose();
    super.dispose();
  }

  Future<void> loadState() async {
    userRepository.loginStatusStream.listen((isLoggedIn) {
      state = state.copyWith(isLoggedIn: isLoggedIn);
    }).addTo(subscriptions);
  }

  Future<void> onSelectNavigationItem(int index) async {
    state = state.copyWith(
      selectedTabIndex: index,
    );

    switch (index) {
      case 0:
        goRouter.go('/');
      case 1:
        goRouter.go('/login');
      case 2:
        goRouter.go('/register');
      default:
        goRouter.go('/');
    }
  }
}
