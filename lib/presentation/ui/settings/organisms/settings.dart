import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:real_world_flutter/domain/repository/user_repository.dart';

class Settings extends HookConsumerWidget {
  const Settings({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Center(
      child: Column(
        children: [
          ElevatedButton(
            onPressed: () {
              ref.watch(UserRepository.provider).signOut();
            },
            child: Text('Or click here to logout.'),
          ),
        ],
      ),
    );
  }
}
