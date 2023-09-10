import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:real_world_flutter/main.dart';
import 'package:real_world_flutter/presentation/ui/profile/molecules/shared/profile_follow_notifier.dart';

class ProfileFollowButton extends HookConsumerWidget {
  final String? username;

  const ProfileFollowButton({
    super.key,
    this.username,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final username = this.username;
    if (username == null) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    final followProvider = ProfileFollowNotifier.provider(username);
    final followNotifier = ref.watch(followProvider.notifier);
    final followState = ref.watch(followProvider);

    return ElevatedButton(
      onPressed:
          followState.lockFollowButton ? null : followNotifier.onTapFollow,
      style: followState.follwoing ? _selectedStyle : _normalStyle,
      child: Text(followState.follwoing ? 'Following' : 'Follow'),
    );
  }

  ButtonStyle get _normalStyle {
    return ButtonStyle(
      surfaceTintColor: const MaterialStatePropertyAll(Colors.transparent),
      backgroundColor: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.disabled)) {
          return AppColors.lightGray;
        } else if (states.contains(MaterialState.pressed)) {
          return AppColors.grey;
        } else {
          return Colors.transparent;
        }
      }),
      foregroundColor: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.disabled)) {
          return AppColors.grey;
        } else if (states.contains(MaterialState.pressed)) {
          return AppColors.white;
        } else {
          return AppColors.lightGray;
        }
      }),
      shadowColor: const MaterialStatePropertyAll(Colors.transparent),
      overlayColor: MaterialStateProperty.resolveWith((states) {
        return states.contains(MaterialState.pressed)
            ? AppColors.lightGray
            : Colors.transparent;
      }),
      shape: MaterialStateProperty.all(RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4),
      )),
      side: const MaterialStatePropertyAll(
        BorderSide(color: AppColors.lightGray),
      ),
    );
  }

  ButtonStyle get _selectedStyle {
    return ButtonStyle(
      surfaceTintColor: const MaterialStatePropertyAll(Colors.transparent),
      backgroundColor: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.disabled)) {
          return AppColors.darkGrey;
        } else if (states.contains(MaterialState.pressed)) {
          return AppColors.white;
        } else {
          return AppColors.lightGray;
        }
      }),
      foregroundColor: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.disabled)) {
          return AppColors.darkGrey;
        } else if (states.contains(MaterialState.pressed)) {
          return AppColors.white;
        } else {
          return AppColors.darkGrey;
        }
      }),
      shadowColor: const MaterialStatePropertyAll(Colors.transparent),
      overlayColor: MaterialStateProperty.resolveWith((states) {
        return states.contains(MaterialState.pressed)
            ? AppColors.darkGrey
            : Colors.transparent;
      }),
      shape: MaterialStateProperty.all(RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4),
      )),
      side: const MaterialStatePropertyAll(
        BorderSide(color: AppColors.lightGray),
      ),
    );
  }
}
