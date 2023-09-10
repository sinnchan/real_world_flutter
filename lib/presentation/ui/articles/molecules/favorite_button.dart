import 'package:flutter/material.dart';
import 'package:real_world_flutter/main.dart';

class FavoriteButton extends StatelessWidget {
  const FavoriteButton({
    super.key,
    this.favorited = false,
    required this.favoritesCount,
    this.onTap,
  });

  final bool favorited;
  final int favoritesCount;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onTap,
      style: favorited ? null : _normalStyle,
      child: Row(
        children: [
          const Icon(
            Icons.favorite,
            size: 16,
          ),
          const SizedBox(width: 2),
          Text(favoritesCount.toString()),
        ],
      ),
    );
  }

  ButtonStyle get _normalStyle {
    return ButtonStyle(
      surfaceTintColor: const MaterialStatePropertyAll(Colors.transparent),
      backgroundColor: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.disabled)) {
          return AppColors.lightGray;
        } else if (states.contains(MaterialState.pressed)) {
          return AppColors.main;
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
          return AppColors.main;
        }
      }),
      shadowColor: const MaterialStatePropertyAll(Colors.transparent),
      overlayColor: MaterialStateProperty.resolveWith((states) {
        return states.contains(MaterialState.pressed)
            ? AppColors.main
            : Colors.transparent;
      }),
      shape: MaterialStateProperty.all(RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4),
      )),
      side: const MaterialStatePropertyAll(
        BorderSide(color: AppColors.main),
      ),
    );
  }
}
