import 'package:flutter/material.dart';

class ArticleAuthor extends StatelessWidget {
  const ArticleAuthor({
    super.key,
    required this.username,
    required this.image,
    required this.createdAt,
  });

  final Uri image;
  final String username;
  final DateTime createdAt;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: Row(
        children: [
          _icon(),
          const SizedBox(width: 10),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _username(context),
              _date(),
            ],
          )
        ],
      ),
    );
  }

  Widget _icon() {
    return SizedBox.square(
      dimension: 40,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Image.network(
          image.toString(),
          fit: BoxFit.contain,
        ),
      ),
    );
  }

  Widget _date() {
    return Text(
      createdAt.toString(),
      style: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w200,
      ),
    );
  }

  Widget _username(BuildContext context) {
    return Text(
      username,
      style: TextStyle(
        color: Theme.of(context).primaryColor,
        fontSize: 16,
      ),
    );
  }
}
