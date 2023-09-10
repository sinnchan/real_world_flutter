import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:real_world_flutter/presentation/ui/articles/organisms/description/article_description.dart';
import 'package:real_world_flutter/presentation/ui/auth/organisms/sign_in/sign_in.dart';
import 'package:real_world_flutter/presentation/ui/auth/organisms/sign_up/sign_up.dart';
import 'package:real_world_flutter/presentation/ui/feeds/organisms/feeds_tab/feeds_list_tabs.dart';
import 'package:real_world_flutter/presentation/ui/main/main_page.dart';
import 'package:real_world_flutter/presentation/ui/main/sub_page.dart';
import 'package:real_world_flutter/presentation/ui/profile/organisms/profile_contents.dart';
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
                child: FeedsListTabs(),
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
                child: ProfileContents(),
              );
            },
          ),
        ],
      ),
      GoRoute(
        path: '/profile/:username',
        parentNavigatorKey: _rootNavKey,
        redirect: (context, state) {
          final profileUser = state.pathParameters['username'];
          if (profileUser == null) {
            return '/';
          }
          return null;
        },
        pageBuilder: (context, state) {
          final profileUser = state.pathParameters['username'];
          return _pageAnimation(
            ProfileContents(username: profileUser),
          );
        },
      ),
      GoRoute(
        path: '/article/:slug',
        parentNavigatorKey: _rootNavKey,
        redirect: (context, state) {
          final profileUser = state.pathParameters['slug'];
          if (profileUser == null) {
            return '/';
          }
          return null;
        },
        pageBuilder: (context, state) {
          final slug = state.pathParameters['slug']!;
          return _pageAnimation(
            ArticleDescription(slug: slug),
          );
        },
      ),
      // GoRoute(
      //   path: '/editor',
      //   routes: [
      //     GoRoute(path: ':article_slug'),
      //   ],
      // ),
    ],
  );

  CustomTransitionPage<void> _pageAnimation(Widget page) {
    return CustomTransitionPage(
      child: page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: animation,
          child: SlideTransition(
            position: animation.drive(
              Tween(
                begin: const Offset(1, 0),
                end: Offset.zero,
              ).chain(CurveTween(curve: Curves.easeIn)),
            ),
            child: SubPage(child: child),
          ),
        );
      },
    );
  }
}
