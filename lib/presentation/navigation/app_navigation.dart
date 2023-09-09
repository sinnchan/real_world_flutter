import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:real_world_flutter/presentation/ui/articles/organisms/articles_tabs/article_list_tabs.dart';
import 'package:real_world_flutter/presentation/ui/auth/organisms/sign_in/sign_in.dart';
import 'package:real_world_flutter/presentation/ui/auth/organisms/sign_up/sign_up.dart';
import 'package:real_world_flutter/presentation/ui/main/main_page.dart';
import 'package:real_world_flutter/presentation/ui/profile/organisms/profile.dart';
import 'package:real_world_flutter/presentation/ui/settings/organisms/settings.dart';

class AppNavigation {
  final _rootNavKey = GlobalKey<NavigatorState>(debugLabel: 'root');
  final _shellNavKey = GlobalKey<NavigatorState>(debugLabel: 'shell');

  AppNavigation();

  static final provider = Provider.autoDispose((ref) {
    return AppNavigation();
  });

  late final router = GoRouter(
    navigatorKey: _rootNavKey,
    initialLocation: '/',
    routes: [
      ShellRoute(
        navigatorKey: _shellNavKey,
        pageBuilder: (context, state, child) {
          return NoTransitionPage(
            child: MainPage(child: child),
          );
        },
        routes: [
          GoRoute(
            path: '/',
            pageBuilder: (context, state) {
              return const NoTransitionPage(
                child: ArticleListTabs(),
              );
            },
          ),
          GoRoute(
            path: '/login',
            pageBuilder: (context, state) {
              return const NoTransitionPage(
                child: SignIn(),
              );
            },
          ),
          GoRoute(
            path: '/register',
            pageBuilder: (context, state) {
              return const NoTransitionPage(
                child: SignUp(),
              );
            },
          ),
          GoRoute(
            path: '/settings',
            pageBuilder: (context, state) {
              return const NoTransitionPage(
                child: Settings(),
              );
            },
          ),
          GoRoute(
            path: '/my_profile',
            pageBuilder: (context, state) {
              return const NoTransitionPage(
                child: Profile(),
              );
            },
          ),
        ],
      ),
      // GoRoute(
      //   path: '/profile',
      //   redirect: (context, state) {
      //     sLogger.w('profile page requires username.');
      //     return '/';
      //   },
      //   routes: [
      //     GoRoute(
      //       path: ':username',
      //       redirect: (context, state) {
      //         final profileUser = state.pathParameters['username'];
      //         if (profileUser == null) {
      //           return '/';
      //         }
      //         return null;
      //       },
      //       pageBuilder: (context, state) {
      //         return const NoTransitionPage(child: Profile());
      //       },
      //       // routes: [
      //       //   GoRoute(path: 'favorites'),
      //       // ],
      //     ),
      //   ],
      // ),
      // GoRoute(path: '/article/:article_slug'),
      // GoRoute(
      //   path: '/editor',
      //   routes: [
      //     GoRoute(path: ':article_slug'),
      //   ],
      // ),
    ],
  );
}
