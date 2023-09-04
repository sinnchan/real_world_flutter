import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:real_world_flutter/domain/repository/articles_repository.dart';
import 'package:real_world_flutter/domain/repository/user_repository.dart';
import 'package:real_world_flutter/presentation/data_source/articles_data_source.dart';
import 'package:real_world_flutter/presentation/data_source/articles_data_source_type.dart';
import 'package:real_world_flutter/presentation/ui/articles/organisms/articles_view_model.dart';
import 'package:rxdart/utils.dart';

typedef _Vm = ArticlesOrganizmViewModel;
typedef _Notifier = ArticlesStateNotifier;
typedef _Provider = AutoDisposeStateNotifierProvider<_Notifier, _Vm>;

class ArticlesStateNotifier extends StateNotifier<_Vm> {
  final ArticlesRepository articlesRepository;
  final UserRepository userRepository;
  final subscriptions = CompositeSubscription();

  ArticlesStateNotifier(
    super.state, {
    required this.articlesRepository,
    required this.userRepository,
  });

  static final provider = _Provider((ref) {
    return ArticlesStateNotifier(
      const ArticlesOrganizmViewModel(tabs: [], isLoading: true),
      articlesRepository: ref.watch(ArticlesRepository.provider),
      userRepository: ref.watch(UserRepository.provider),
    )..init();
  });

  @override
  void dispose() {
    subscriptions.dispose();
    super.dispose();
  }

  void init() {
    userRepository.loginStatusStream.listen((isLoggedIn) {
      updateTabs(isLoggedIn);
    }).addTo(subscriptions);
  }

  void updateTabs(bool isLoggedIn) {
    state = state.copyWith(isLoading: true);
    final tabs = <ArticlesTab>[];

    if (isLoggedIn) {
      final userTab = ArticlesTab(
        name: 'Your Feed',
        dataSource: ArticlesDataSource(
          type: const ArticlesDataSourceType.myFeed(),
          repository: articlesRepository,
        ),
      );
      tabs.add(userTab);
    }

    final globalTab = ArticlesTab(
      name: 'Global Feed',
      dataSource: ArticlesDataSource(
        type: const ArticlesDataSourceType.global(),
        repository: articlesRepository,
      ),
    );
    tabs.add(globalTab);

    state = state.copyWith(
      isLoading: false,
      tabs: tabs,
    );
  }
}
