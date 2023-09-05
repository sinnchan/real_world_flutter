import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:real_world_flutter/domain/repository/user_repository.dart';
import 'package:real_world_flutter/domain/util/logger.dart';
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
    final goRouter = ref.watch(AppNavigation.provider).router;
    final notifier = MainPageNotifier(
      const _Vm(),
      goRouter: goRouter,
      userRepository: ref.watch(UserRepository.provider),
    )..loadState();

    // setup router info listener
    final routeInfoProvider = goRouter.routeInformationProvider;
    goRouterListener() {
      notifier.onChangeLocationPath(
        goRouter.routerDelegate.currentConfiguration.fullPath,
      );
    }

    routeInfoProvider.addListener(goRouterListener);
    ref.onDispose(() {
      routeInfoProvider.removeListener(goRouterListener);
    });

    return notifier;
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
    switch (index) {
      case 0:
        goRouter.go('/');
      case 1:
        goRouter.go('/login');
      case 2:
        goRouter.go('/settings');
      default:
        goRouter.go('/');
    }
  }

  void onChangeLocationPath(String location) {
    sLogger.i('location: $location');
    switch (location) {
      case '/':
        state = state.copyWith(
          selectedTabIndex: 0,
          isShowActionButton: state.isLoggedIn,
          isShowTagButton: true,
        );
      case '/login':
        state = state.copyWith(
          selectedTabIndex: 1,
          isShowActionButton: false,
          isShowTagButton: false,
        );
      case '/register':
        state = state.copyWith(
          selectedTabIndex: 1,
          isShowActionButton: false,
          isShowTagButton: false,
        );
      case '/profile':
        state = state.copyWith(
          selectedTabIndex: 1,
          isShowActionButton: false,
          isShowTagButton: false,
        );
      case '/settings':
        state = state.copyWith(
          selectedTabIndex: 2,
          isShowActionButton: false,
          isShowTagButton: false,
        );
      default:
        state = state.copyWith(
          selectedTabIndex: 0,
          isShowActionButton: state.isLoggedIn,
          isShowTagButton: true,
        );
    }
  }
}
