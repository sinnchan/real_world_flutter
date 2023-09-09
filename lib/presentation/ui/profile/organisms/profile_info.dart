import 'package:flutter/material.dart';
import 'package:real_world_flutter/domain/model/profile.dart';
import 'package:kotlin_scope_function/kotlin_scope_function.dart';
import 'package:real_world_flutter/main.dart';

class ProfileInfo extends StatelessWidget {
  final loading = const Center(child: CircularProgressIndicator());
  final Profile? profile;

  const ProfileInfo({
    super.key,
    this.profile,
  });

  @override
  Widget build(BuildContext context) {
    final iconImage = profile?.image?.let((it) {
      return Image.network(it.toString());
    });
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(32),
            child: Container(
              color: AppColors.lightGray,
              height: 64,
              width: 64,
              child: iconImage ?? loading,
            ),
          ),
          const SizedBox(height: 10),
          Text(profile?.username ?? '---'),
          const SizedBox(height: 10),
          Text(profile?.bio ?? '---'),
        ],
      ),
    );
  }
}
