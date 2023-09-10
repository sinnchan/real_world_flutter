import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:real_world_flutter/domain/repository/tag_repository.dart';
import 'package:real_world_flutter/domain/repository/user_repository.dart';
import 'package:real_world_flutter/domain/util/logger.dart';
import 'package:real_world_flutter/presentation/navigation/app_navigation.dart';
import 'package:real_world_flutter/presentation/ui/feeds/organisms/feeds_tab/feeds_state_notifier.dart';
import 'package:real_world_flutter/presentation/ui/main/main_view_model.dart';
import 'package:rxdart/utils.dart';

typedef _Vm = MainViewModel;
typedef _Notifier = MainPageNotifier;
typedef _Provider = AutoDisposeStateNotifierProvider<_Notifier, _Vm>;

class MainPageNotifier extends StateNotifier<MainViewModel> {
  final GoRouter goRouter;
  final UserRepository userRepository;
  final TagRepository tagRepository;
  final FeedsStateNotifier feedsNotifier;
  final subscriptions = CompositeSubscription();
  var isLoggedIn = false;
  var _isDisposed = false;

  MainPageNotifier(
    super.state, {
    required this.goRouter,
    required this.userRepository,
    required this.tagRepository,
    required this.feedsNotifier,
  });

  static final provider = _Provider((ref) {
    sLogger.d('Instantinate main notifier');
    final goRouter = ref.watch(AppNavigation.provider).router;
    final notifier = MainPageNotifier(
      const _Vm(),
      goRouter: goRouter,
      userRepository: ref.watch(UserRepository.provider),
      tagRepository: ref.watch(TagRepository.provider),
      feedsNotifier: ref.watch(FeedsStateNotifier.provider.notifier),
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
    _isDisposed = true;
    sLogger.d('Dispose main notifier');
    super.dispose();
  }

  Future<void> loadState() async {
    userRepository.loginStatusStream.listen((isLoggedIn) {
      sLogger.i('updated login status: $isLoggedIn');
      this.isLoggedIn = isLoggedIn;
      state = state.copyWith(isShowSettingBottomTab: isLoggedIn);
      goRouter.go('/');
    }).addTo(subscriptions);
  }

  Future<void> onTapOpenTag() async {
    final result = await tagRepository.getTags();
    result.whenOrNull(
      success: (tags) {
        if (!_isDisposed) {
          state = state.copyWith(tags: tags);
        }
      },
    );
  }

  void onTapTag(String tag) {
    feedsNotifier.addTagTab(tag);
  }

  Future<void> onSelectNavigationItem(int index) async {
    switch (index) {
      case 0:
        goRouter.go('/');
      case 1:
        if (isLoggedIn) {
          goRouter.go('/my_profile');
        } else {
          goRouter.go('/login');
        }
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
          isShowActionButton: isLoggedIn,
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
      case '/my_profile':
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
          isShowActionButton: isLoggedIn,
          isShowTagButton: true,
        );
    }
  }

  void onTapEditButton() {
    goRouter.push('/editor');
  }
}
