import 'package:flutter/material.dart';

class FavoriteCounter extends StatelessWidget {
  const FavoriteCounter({
    super.key,
    required this.favoritesCount,
  });

  final int favoritesCount;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border.all(
          color: Theme.of(context).primaryColor,
        ),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        children: [
          Icon(
            Icons.favorite,
            size: 16,
            color: Theme.of(context).primaryColor,
          ),
          const SizedBox(width: 2),
          Text(
            '$favoritesCount',
            style: TextStyle(
              color: Theme.of(context).primaryColor,
            ),
          ),
        ],
      ),
    );
  }
}
